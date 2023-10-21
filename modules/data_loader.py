import requests


class DataLoader:
    def __init__(self, db_connection):
        self.db_connection = db_connection

    def load_assets(self):
        asset_objects = self.__load_mosp_api_data({"schema": "Assets"}, {"X-Fields": "data{name, json_object}"})["data"]
        asset_objects = [asset["json_object"] for asset in asset_objects]
        for asset in asset_objects:
            if "authors" in asset.keys():
                asset["authors"] = ",".join(asset["authors"])
        self.db_connection.insert_data(asset_objects, "assets")

    def load_risks(self):
        vulnerability_objects = self.__load_mosp_api_data({"schema": "Vulnerabilities"}, {"X-Fields": "data{name, json_object}"})["data"]
        vulnerability_objects = [vulnerability["json_object"] for vulnerability in vulnerability_objects]
        for vulnerability in vulnerability_objects:
            if "authors" in vulnerability.keys():
                vulnerability["authors"] = ",".join(vulnerability["authors"])
            if "mode" in vulnerability.keys():
                del vulnerability["mode"]
        self.db_connection.insert_data(vulnerability_objects, "vulnerabilities")

        threat_objects = self.__load_mosp_api_data({"schema": "Threats"}, {"X-Fields": "data{name, json_object}"})["data"]
        threat_objects = [threat["json_object"] for threat in threat_objects]
        for threat in threat_objects:
            if "authors" in threat.keys():
                threat["authors"] = ",".join(threat["authors"])
        self.db_connection.insert_data(threat_objects, "threats")

        risk_objects = self.__load_mosp_api_data({"schema": "Risks"}, {"X-Fields": "data{json_object}"})["data"]
        risk_objects = [risk["json_object"] for risk in risk_objects]
        for risk in risk_objects:
            if "authors" in risk.keys():
                risk["authors"] = ",".join(risk["authors"])
            if "measures" in risk.keys():
                risk["measures"] = ",".join(risk["measures"])
        self.db_connection.insert_data(risk_objects, "risks")

    def __load_mosp_api_data(self, params, headers):
        params.update({"per_page": 5000})
        objects = requests.get("https://objects.monarc.lu/api/v2/object", params, headers=headers).json()

        return objects
