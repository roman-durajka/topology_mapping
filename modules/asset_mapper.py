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
        mapped_devices = {}
        # {device_id: {name: ..., risks: {risk_uuid: {vulnerability:..., threat:...}}}}

        for device in devices:
            device_id = str(device.device_id)
            mapped_devices[device_id] = {}
            mapped_devices[device_id]["name"] = device.name
            mapped_devices[device_id]["risks"] = {}
            for m_asset_type, m_uuid in self.asset_mapping_json[device.asset].items():
                mapped_devices[device_id]["risks"].update(mapped_risks[m_uuid]["risks"])

        return mapped_devices

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
    """Function to returns assets/risks/vulnerabilities/threats fired from one of API endpoints."""
    risk_mgmt_db_client = MariaDBClient("risk_management")
    topology_db_client = MariaDBClient("librenms")

    device_extractor = DeviceExtractor(topology_db_client)
    devices = device_extractor.extract()

    asset_mapper = AssetMapper(risk_mgmt_db_client)
    mapped_devices = asset_mapper.assign_risks_to_devices(devices)

    return mapped_devices
