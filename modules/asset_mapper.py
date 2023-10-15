import json, pymosp, requests, time
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

    def assign_risks_to_devices(self, devices: list):
        # first method - 20+- and 0.03

        tik = time.perf_counter()

        # fetch all necessary data
        risk_objects = self.__load_api_data({"schema": "Risks"}, {"X-Fields": "data{json_object}"})["data"]
        vulnerability_objects = self.__load_api_data({"schema": "Vulnerabilities"}, {"X-Fields": "data{name, json_object}"})["data"]
        threat_objects = self.__load_api_data({"schema": "Threats"}, {"X-Fields": "data{name, json_object}"})["data"]

        tak = time.perf_counter()
        print(f"Download time: {tak-tik} seconds")
        tik = time.perf_counter()

        m_uuids = []
        for l_asset_type, value in self.asset_mapping_json.items():
            for m_asset_type, m_uuid in value.items():
                if m_uuid not in m_uuids:
                    m_uuids.append(m_uuid)

        mapped_risks = self.__map_risks_to_assets(m_uuids, risk_objects, vulnerability_objects, threat_objects)

        for device in devices:
            for m_asset_type, m_uuid in self.asset_mapping_json[device.asset].items():
                device.vulnerabilities.extend(mapped_risks[m_uuid]["vulnerabilities"])
                device.threats.extend(mapped_risks[m_uuid]["threats"])

        tak = time.perf_counter()
        print(f"Loop time: {tak - tik} seconds")

        # second method: 175.39 seconds

        # tik = time.perf_counter()
        #
        # mapped_assets = {}
        # mapped_risks = {}
        #
        # for device in devices:
        #     mosp_assets_uuids = self.asset_mapping_json[device.asset].values()
        #     for mosp_asset_uuid in mosp_assets_uuids:
        #         if mosp_asset_uuid in mapped_assets:
        #             for risk_uuid in mapped_assets[mosp_asset_uuid]["risks"]:
        #                 device.vulnerabilities.append(mapped_risks[risk_uuid]["vulnerability"])
        #                 device.threats.append(mapped_risks[risk_uuid]["threat"])
        #             continue
        #         mapped_assets[mosp_asset_uuid] = {"risks": []}
        #
        #         asset_api_data = self.__load_api_data({"schema": "Assets",
        #                                                "uuid": mosp_asset_uuid,
        #                                                "x-fields": "data{id}"})
        #         asset_api_id = asset_api_data["data"][0]["id"]
        #         object_soup = self.__request_object_soup(asset_api_id)
        #         for risk_uuid in self.__parse_objects_reffered_by(object_soup):
        #             mapped_assets[mosp_asset_uuid]["risks"].append(risk_uuid)
        #             if risk_uuid in mapped_risks:
        #                 device.vulnerabilities.append(mapped_risks[risk_uuid]["vulnerability"])
        #                 device.threats.append(mapped_risks[risk_uuid]["threat"])
        #                 continue
        #
        #             risk_object = self.__load_api_data({"uuid": risk_uuid,
        #                                                 "schema": "Risks"})
        #             vulnerability_uuid = risk_object["data"][0]["json_object"]["vulnerability"]
        #             threat_uuid = risk_object["data"][0]["json_object"]["threat"]
        #             vulnerability_name = self.__load_api_data({"uuid": vulnerability_uuid,
        #                                                        "schema": "Vulnerabilities"})
        #             threat_name = self.__load_api_data({"uuid": threat_uuid,
        #                                                 "schema": "Threats"})
        #
        #             device.vulnerabilities.append(vulnerability_name)
        #             device.threats.append(threat_name)
        #
        #             mapped_risks[risk_uuid] = {"vulnerability": vulnerability_name,
        #                                        "threat": threat_name}
        #
        # tak = time.perf_counter()
        #
        # print(f"Vsetko trvalo {tak - tik} sekund")

    def __map_risks_to_assets(self, asset_uuids: list,
                                risk_objects: list,
                                vulnerability_objects: list,
                                threat_objects: list):
        mapped_risks = {}  # {asset_uuid: {threats: [], vulnerabilities: []}}

        for risk_object in risk_objects:
            risk_asset_uuid = risk_object["json_object"]["asset"]
            if risk_asset_uuid in asset_uuids:
                vulnerability_uuid = risk_object["json_object"]["vulnerability"]
                threat_uuid = risk_object["json_object"]["threat"]
                for vulnerability_object in vulnerability_objects:
                    if vulnerability_object["json_object"]["uuid"] == vulnerability_uuid:
                        vulnerability_name = vulnerability_object["name"]

                        if risk_asset_uuid not in mapped_risks:
                            mapped_risks[risk_asset_uuid] = {"threats": [], "vulnerabilities": []}
                        mapped_risks[risk_asset_uuid]["vulnerabilities"].append(vulnerability_name)
                        break
                for threat_object in threat_objects:
                    if threat_object["json_object"]["uuid"] == threat_uuid:
                        threat_name = threat_object["name"]

                        if risk_asset_uuid not in mapped_risks:
                            mapped_risks[risk_asset_uuid] = {"threats": [], "vulnerabilities": []}
                        mapped_risks[risk_asset_uuid]["threats"].append(threat_name)
                        break

        return mapped_risks

    def __load_api_data(self, params, headers):
        params.update({"per_page": 5000})
        objects = requests.get("https://objects.monarc.lu/api/v2/object", params, headers=headers).json()

        # mosp = pymosp.PyMOSP(CONFIG.get("MOSP_URL_API", ""), CONFIG.get("TOKEN", ""))
        # params.update({"per_page": 5000})
        # objects = mosp.objects(params=params)

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
