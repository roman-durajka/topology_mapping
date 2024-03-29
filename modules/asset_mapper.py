import json

from modules.clients import MariaDBClient
from extractors import DeviceExtractor


class AssetMapper:
    def __init__(self, db_connection: MariaDBClient):
        self.asset_mapping_json = self.__read_asset_mapping_json()

        self.db_connection = db_connection

    def __read_asset_mapping_json(self):
        with open("./data/asset_mapping.json", "r") as f:
            raw_json = f.read()

        asset_mapping_dict = json.loads(raw_json)
        return asset_mapping_dict

    def assign_risks_to_devices(self, devices: list):
        m_uuids = []
        for l_asset_type, value in self.asset_mapping_json.items():
            for m_asset_type, m_uuid in value.items():
                if m_uuid not in m_uuids:
                    m_uuids.append(m_uuid)

        mapped_risks = self.__map_risks_to_assets(m_uuids)

        for device in devices:
            for m_asset_type, m_uuid in self.asset_mapping_json[device.asset].items():
                for key, item in mapped_risks[m_uuid]["risks"].items():
                    device.vulnerabilities.append(item["vulnerability"])
                    device.threats.append(item["threat"])

        return devices

    def __map_risks_to_assets(self, asset_uuids: list):
        mapped_risks = {}  # {asset_uuid: {risks: risk_uuid: {threat: ..., threat_uuid: ..., vulnerability: ..., vulnerability_uuid: ...}}}
        for asset_uuid in asset_uuids:
            mapped_risks[asset_uuid] = {"risks": {}}
            risk_records = self.db_connection.get_data("risks", [("asset", asset_uuid)])
            for risk_record in risk_records:
                vulnerability_uuid = risk_record["vulnerability"]
                threat_uuid = risk_record["threat"]
                risk_uuid = risk_record["uuid"]

                vulnerability_records = self.db_connection.get_data("vulnerabilities", [("uuid", vulnerability_uuid)])
                vulnerability_record = vulnerability_records[0]
                vulnerability_name = vulnerability_record["label"]

                threat_records = self.db_connection.get_data("threats", [("uuid", threat_uuid)])
                threat_record = threat_records[0]
                threat_name = threat_record["label"]

                mapped_risks[asset_uuid]["risks"][risk_uuid] = {"vulnerability": vulnerability_name, "threat": threat_name,
                                                                "vulnerability_uuid": vulnerability_uuid, "threat_uuid": threat_uuid}

        return mapped_risks


def get_mapped_assets():
    """Function to returns devices with mapped assets/risks/vulnerabilities/threats."""
    risk_mgmt_db_client = MariaDBClient("risk_management")
    librenms_db_client = MariaDBClient("librenms")

    device_extractor = DeviceExtractor(librenms_db_client)
    devices = device_extractor.extract()

    asset_mapper = AssetMapper(risk_mgmt_db_client)
    mapped_devices = asset_mapper.assign_risks_to_devices(devices)

    return mapped_devices


def get_application_groups():
    topology_db_client = MariaDBClient("topology")
    librenms_db_client = MariaDBClient("librenms")
    records = topology_db_client.get_data("application_groups")

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
