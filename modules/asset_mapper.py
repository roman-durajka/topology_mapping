import json
import time

from modules.clients import MariaDBClient


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
        tik = time.perf_counter()

        # fetch all necessary data
        tak = time.perf_counter()
        print(f"Download time: {tak-tik} seconds")
        tik = time.perf_counter()

        m_uuids = []
        for l_asset_type, value in self.asset_mapping_json.items():
            for m_asset_type, m_uuid in value.items():
                if m_uuid not in m_uuids:
                    m_uuids.append(m_uuid)

        mapped_risks = self.__map_risks_to_assets(m_uuids)

        for device in devices:
            for m_asset_type, m_uuid in self.asset_mapping_json[device.asset].items():
                device.vulnerabilities.extend(mapped_risks[m_uuid]["vulnerabilities"])
                device.threats.extend(mapped_risks[m_uuid]["threats"])

    def __map_risks_to_assets(self, asset_uuids: list):
        mapped_risks = {}  # {asset_uuid: {threats: [], vulnerabilities: []}}
        for asset_uuid in asset_uuids:
            mapped_risks[asset_uuid] = {"threats": [], "vulnerabilities": []}
            risk_records = self.db_connection.get_data("risks", [("asset", asset_uuid)])
            for risk_record in risk_records:
                vulnerability_uuid = risk_record["vulnerability"]
                threat_uuid = risk_record["threat"]

                vulnerability_records = self.db_connection.get_data("vulnerabilities", [("uuid", vulnerability_uuid)])
                vulnerability_record = vulnerability_records[0]
                vulnerability_name = vulnerability_record["label"]

                threat_records = self.db_connection.get_data("threats", [("uuid", threat_uuid)])
                threat_record = threat_records[0]
                threat_name = threat_record["label"]

                mapped_risks[asset_uuid]["vulnerabilities"].append(vulnerability_name)
                mapped_risks[asset_uuid]["threats"].append(threat_name)

        return mapped_risks
