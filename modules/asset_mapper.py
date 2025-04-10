import json
import copy

from modules.clients import MariaDBClient
from extractors import DeviceExtractor


class AssetMapper:
    def __init__(self, db_connection: MariaDBClient):
        self.asset_mapping_json = self.__read_asset_mapping_json()
        self.processed_risks = {}

        self.db_connection = db_connection
        self.topology_db_connection = MariaDBClient("topology")

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
                vulnerability = {vulnerability_uuid: {"name": vulnerability_name}}

                threat_records = self.db_connection.get_data("threats", [("uuid", threat_uuid)])
                threat_record = threat_records[0]
                threat_name = threat_record["label"]
                threat = {threat_uuid: {"name": threat_name}}

                measures = {}
                measure_risks_map_records = self.db_connection.get_data("measures_risks_map", [("risk_id", risk_uuid)])
                for measure_map_record in measure_risks_map_records:
                    measure_uuid = measure_map_record["measure_id"]
                    measure_record = self.db_connection.get_data("measures_iso_27002", [("uuid", measure_uuid)])
                    if not measure_record:
                        continue

                    measure_record = measure_record[0]
                    measure_name = measure_record["label"]
                    measure_effectiveness = 0
                    measure_topology_record = self.topology_db_connection.get_data("treatments", [("uuid", measure_uuid)])
                    if measure_topology_record:
                        measure_effectiveness = measure_topology_record[0]["effectiveness"]

                    measures[measure_uuid] = {"name": measure_record["label"], "effectiveness": measure_effectiveness}

                mapped_risk = {"vulnerability": vulnerability,
                               "threat": threat,
                               "measures": measures}

                mapped_risks[asset_uuid]["risks"][risk_uuid] = mapped_risk
                if risk_uuid not in self.processed_risks.keys():
                    self.processed_risks.update({risk_uuid: mapped_risk})

        return mapped_risks

    def update_asset_values(self, table_name: str, data: dict):
        if not self.db_connection.get_data(table_name, [("uuid", data["uuid"])]):
            self.db_connection.insert_data([data], table_name)
        else:
            uuid = data["uuid"]
            new_data = {key: data[key] for key in data if key != "uuid"}
            self.db_connection.update_data(table_name, [new_data], [("uuid", f"\'{uuid}\'")])

def update_asset(data: dict):
    db_client = MariaDBClient("topology")
    asset_mapper = AssetMapper(db_client)
    if "effectiveness" in data.keys():
        asset_mapper.update_asset_values("treatments", data)
    else:
        asset_mapper.update_asset_values("assets", data)

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
                        device_info["asset"] = copy.deepcopy(device_risk_mgmt)
                        topology_group_data = topology_db_client.get_data("paths", [("path_id", path_id)])[0]
                        for asset_uuid, asset_items in device_info["asset"].items():
                            risks = asset_items["risks"]
                            for uuid in risks.keys():
                                asset_data = topology_db_client.get_data("assets", [("uuid", f"{device_id}-{uuid}")])
                                if asset_data:
                                    asset_data = asset_data[0]
                                    if asset_data["c"] != 0:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["c"] = asset_data["c"]
                                    else:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["c"] = topology_group_data["confidentality_value"]
                                    if asset_data["i"] != 0:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["i"] = asset_data["i"]
                                    else:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["i"] = topology_group_data["integrity_value"]
                                    if asset_data["a"] != 0:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["a"] = asset_data["a"]
                                    else:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["a"] = topology_group_data["availability_value"]
                                    if asset_data["threat_prob"] != 0:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["threat_prob"] = asset_data["threat_prob"]
                                    else:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["threat_prob"] = 1
                                    if asset_data["vulnerability_qualif"] != 0:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["vulnerability_qualif"] = asset_data["vulnerability_qualif"]
                                    else:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["vulnerability_qualif"] = 1
                                    if asset_data["treatment"] != "":
                                        device_info["asset"][asset_uuid]["risks"][uuid]["treatment"] = asset_data["treatment"]
                                    else:
                                        device_info["asset"][asset_uuid]["risks"][uuid]["treatment"] = ""
                                else:
                                    topology_group_data = topology_db_client.get_data("paths", [("path_id", path_id)])[0]
                                    device_info["asset"][asset_uuid]["risks"][uuid]["c"] = topology_group_data["confidentality_value"]
                                    device_info["asset"][asset_uuid]["risks"][uuid]["i"] = topology_group_data["integrity_value"]
                                    device_info["asset"][asset_uuid]["risks"][uuid]["a"] = topology_group_data["availability_value"]
                                    device_info["asset"][asset_uuid]["risks"][uuid]["threat_prob"] = 1
                                    device_info["asset"][asset_uuid]["risks"][uuid]["vulnerability_qualif"] = 1
                                    device_info["asset"][asset_uuid]["risks"][uuid]["treatment"] = ""

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
