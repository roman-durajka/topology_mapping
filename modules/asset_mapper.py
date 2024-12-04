import json

from modules.clients import MariaDBClient
from extractors import DeviceExtractor


class AssetMapper:
    def __init__(self, db_connection: MariaDBClient):
        self.asset_mapping_json = self.__read_asset_mapping_json()
        self.processed_risks = {}

        self.db_connection = db_connection

    def __read_asset_mapping_json(self):
        with open("./data/asset_mapping.json", "r") as f:
            raw_json = f.read()

        asset_mapping_dict = json.loads(raw_json)
        return asset_mapping_dict

    def get_asset_risks(self, asset_type):
        mosp_asset_uuids = []
        for mosp_asset_type, mosp_asset_uuid in self.asset_mapping_json[asset_type].items():
            if mosp_asset_uuid not in mosp_asset_uuids:
                mosp_asset_uuids.append(mosp_asset_uuid)

        mapped_risks = self.__map_risks_to_asset(mosp_asset_uuids)

        return mapped_risks

    def __map_risks_to_asset(self, asset_uuids: list):
        mapped_risks = {}  # {asset_uuid: {risks: risk_uuid: {threat: {threat_uuid: threat_name}, vulnerability: {vulnerability_id: vulnerability_name}, measures: {measure_id: label}}}}
        for asset_uuid in asset_uuids:
            mapped_risks[asset_uuid] = {"risks": {}}

            asset_record = self.db_connection.get_data("assets", [("uuid", asset_uuid)])
            if not asset_record:
                continue

            asset_record = asset_record[0]
            asset_name = asset_record["label"]
            mapped_risks[asset_uuid]["asset_name"] = asset_name

            risk_records = self.db_connection.get_data("risks", [("asset", asset_uuid)])
            for risk_record in risk_records:
                risk_uuid = risk_record["uuid"]
                if risk_uuid in self.processed_risks.keys():
                    mapped_risk = self.processed_risks[risk_uuid]
                    mapped_risks[asset_uuid]["risks"][risk_uuid] = mapped_risk
                    continue

                vulnerability_uuid = risk_record["vulnerability"]
                threat_uuid = risk_record["threat"]

                vulnerability_records = self.db_connection.get_data("vulnerabilities", [("uuid", vulnerability_uuid)])
                vulnerability_record = vulnerability_records[0]
                vulnerability_name = vulnerability_record["label"]
                vulnerability_qualification = vulnerability_record["qualification"]
                vulnerability = {vulnerability_uuid: {"name": vulnerability_name, "qualification": vulnerability_qualification}}

                threat_records = self.db_connection.get_data("threats", [("uuid", threat_uuid)])
                threat_record = threat_records[0]
                threat_name = threat_record["label"]
                threat_probability = threat_record["probability"]
                threat = {threat_uuid: {"name": threat_name, "probability": threat_probability}}

                measures = {}
                measure_risks_map_records = self.db_connection.get_data("measures_risks_map", [("risk_id", risk_uuid)])
                for measure_map_record in measure_risks_map_records:
                    measure_uuid = measure_map_record["measure_id"]
                    measure_record = self.db_connection.get_data("measures_iso_27002", [("uuid", measure_uuid)])
                    if not measure_record:
                        continue

                    measure_record = measure_record[0]
                    measure_name = measure_record["label"]
                    measure_efectiveness = measure_record["efectiveness"]

                    measures[measure_uuid] = {"name": measure_record["label"], "efectiveness": measure_efectiveness}

                mapped_risk = {"vulnerability": vulnerability,
                               "threat": threat,
                               "measures": measures}

                mapped_risks[asset_uuid]["risks"][risk_uuid] = mapped_risk
                if risk_uuid not in self.processed_risks.keys():
                    self.processed_risks.update({risk_uuid: mapped_risk})

        return mapped_risks


# TODO: rework application group functions below into class, fe. ApplicationGroups

def get_application_groups(load_risks: bool):
    topology_db_client = MariaDBClient("topology")
    librenms_db_client = MariaDBClient("librenms")
    records = topology_db_client.get_data("application_groups")

    risk_management_db_client = MariaDBClient("risk_management")
    asset_mapper = AssetMapper(risk_management_db_client)

    application_groups = {}
    for application_group_record in records:
        group_id = application_group_record["id"]
        group_name = application_group_record["name"]
        application_groups[group_id] = {"application_group_name": group_name, "paths": {}}

        path_records = topology_db_client.get_data("paths", [("application_group_id", group_id)])

        for path_record in path_records:
            path_id = path_record["path_id"]
            if path_id not in application_groups[group_id]["paths"].keys():  # add information system and path name
                information_systems_records = topology_db_client.get_data("information_systems", [("path_id", path_id)])
                application_groups[group_id]["paths"][path_id] = {"devices": {},
                                                                  "path_name": path_record["name"],
                                                                  "information_systems": [record["information_system"] for record in information_systems_records]}

            relation_id = path_record["relation_id"]
            relation_data = topology_db_client.get_data("relations", [("id", relation_id)])[0]
            for device_id in [relation_data["source"], relation_data["target"]]:
                if device_id not in application_groups[group_id]["paths"][path_id]["devices"].keys():
                    librenms_device_data = librenms_db_client.get_data("devices", [("device_id", device_id)])[0]
                    device_name = librenms_device_data["sysName"]
                    device_os = librenms_device_data["os"]
                    device_model = librenms_device_data["hardware"]

                    topology_device_data = topology_db_client.get_data("nodes", [("id", device_id)])[0]
                    device_type = topology_device_data["type"]

                    device_info = {"os": device_os,
                                   "name": device_name,
                                   "model": device_model,
                                   "type": device_type}

                    if load_risks:
                        device_asset_type = librenms_device_data["type"]
                        device_risk_mgmt = asset_mapper.get_asset_risks(device_asset_type)
                        device_info["asset"] = device_risk_mgmt

                        device_info["confidentality"] = topology_device_data["confidentality_value"]
                        device_info["integrity"] = topology_device_data["integrity_value"]
                        device_info["availability"] = topology_device_data["availability_value"]

                    application_groups[group_id]["paths"][path_id]["devices"].update({device_id: device_info})

    return application_groups


def update_application_groups(req_json):
    topology_db_client = MariaDBClient("topology")

    for field, data in req_json.items():
        if field == "pathName":
            if data:
                topology_db_client.update_data("paths", [{"name": data}], [("path_id", req_json["pathId"])])
        elif field == "informationSystems":
            topology_db_client.remove_data([("path_id", req_json["pathId"])], "information_systems")
            information_systems = []
            for item in data.split(","):
                if item:
                    information_systems.append({"path_id": req_json["pathId"], "information_system": item})
            if information_systems:
                topology_db_client.insert_data(information_systems, "information_systems")
        elif field == "applicationGroupName":
            topology_db_client.update_data("application_groups", [{"name": data}], [("id", req_json["applicationGroupId"])])
