import json, pymosp


CONFIG = {"MOSP_URL_API": "https://objects.monarc.lu/api/v2/", "TOKEN": ""}


class AssetMapper:
    def __init__(self):
        self.asset_mapping_json = self.__read_asset_mapping_json()

    def __read_asset_mapping_json(self):
        with open("./data/asset_mapping.json", "r") as f:
            raw_json = f.read()

        asset_mapping_dict = json.loads(raw_json)
        return asset_mapping_dict

    def map_risks_to_assets(self, devices: list):
        """TODO"""

        api_data = self.__load_api_data({"schema": "Risks"})
        vulns = []
        threats = []
        for device in devices:
            processed_uuids = []

            mosp_assets = self.asset_mapping_json[device.asset]
            mosp_assets_values = mosp_assets.values()
            for risk_object in api_data["data"]:
                if risk_object["json_object"]["asset"] in mosp_assets_values:
                    threat_uuid = risk_object["json_object"]["threat"]
                    vulnerability_uuid = risk_object["json_object"]["vulnerability"]
                    if threat_uuid not in processed_uuids:
                        new_threat = self.__load_api_data({"uuid": threat_uuid})
                        threats.append(new_threat["data"][0]["name"])
                        processed_uuids.append(threat_uuid)
                    if vulnerability_uuid not in processed_uuids:
                        new_vulne = self.__load_api_data({"uuid": vulnerability_uuid})
                        vulns.append(new_vulne["data"][0]["name"])
                        processed_uuids.append(vulnerability_uuid)
            device.vulns = vulns
            device.threats = threats

    def __load_api_data(self, params):
        mosp = pymosp.PyMOSP(CONFIG.get("MOSP_URL_API", ""), CONFIG.get("TOKEN", ""))
        params.update({"per_page": 5000})
        objects = mosp.objects(params=params)

        return objects
