import json, pymosp, requests
from bs4 import BeautifulSoup


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
        mapped_assets = {}
        mapped_risks = {}

        for device in devices:
            mosp_assets_uuids = self.asset_mapping_json[device.asset].values()
            for mosp_asset_uuid in mosp_assets_uuids:
                print(f"new asset: {mosp_asset_uuid}")
                if mosp_asset_uuid in mapped_assets:
                    for risk_uuid in mapped_assets[mosp_asset_uuid]["risks"]:
                        device.vulnerabilities.append(mapped_risks[risk_uuid]["vulnerability"])
                        device.threats.append(mapped_risks[risk_uuid]["threat"])
                    continue
                mapped_assets[mosp_asset_uuid] = {"risks": []}

                asset_api_data = self.__load_api_data({"schema": "Assets",
                                                       "uuid": mosp_asset_uuid,
                                                       "x-fields": "data{id}"})
                asset_api_id = asset_api_data["data"][0]["id"]
                object_soup = self.__request_object_soup(asset_api_id)
                for risk_uuid in self.__parse_objects_reffered_by(object_soup):
                    mapped_assets[mosp_asset_uuid]["risks"].append(risk_uuid)
                    if risk_uuid in mapped_risks:
                        device.vulnerabilities.append(mapped_risks[risk_uuid]["vulnerability"])
                        device.threats.append(mapped_risks[risk_uuid]["threat"])
                        continue

                    risk_object = self.__load_api_data({"uuid": risk_uuid,
                                                        "schema": "Risks"})
                    vulnerability_uuid = risk_object["data"][0]["json_object"]["vulnerability"]
                    threat_uuid = risk_object["data"][0]["json_object"]["threat"]
                    vulnerability_name = self.__load_api_data({"uuid": vulnerability_uuid,
                                                               "schema": "Vulnerabilities"})
                    threat_name = self.__load_api_data({"uuid": threat_uuid,
                                                        "schema": "Threats"})

                    device.vulnerabilities.append(vulnerability_name)
                    device.threats.append(threat_name)

                    mapped_risks[risk_uuid] = {"vulnerability": vulnerability_name,
                                               "threat": threat_name}

    def __load_api_data(self, params):
        mosp = pymosp.PyMOSP(CONFIG.get("MOSP_URL_API", ""), CONFIG.get("TOKEN", ""))
        params.update({"per_page": 5000})
        objects = mosp.objects(params=params)

        return objects

    def __parse_objects_reffered_by(self, soup: BeautifulSoup):
        raw_objects = soup.select("div#referred-to-by > ul.list-group > li")
        for raw_object in raw_objects:
            text_object = raw_object.select_one("a")
            object_uuid = text_object.text
            yield object_uuid

    def __request_object_soup(self, object_id: int) -> BeautifulSoup:
        response = requests.get(f"https://objects.monarc.lu/object/view/{object_id}")
        soup = BeautifulSoup(response.content, "lxml")

        return soup
