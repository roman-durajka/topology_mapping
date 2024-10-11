from modules.clients import MariaDBClient

import requests
import re


class DataLoader:
    def __init__(self):
        self.db_connection = MariaDBClient("risk_management")

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

    def load_measures(self):
        measure_objects = self.__load_mosp_api_data({"schema": "Security referentials", "name": "ISO/IEC 27002 [2013]"},
                                                    {"X-Fields": "data{name, json_object}"})["data"]
        measure_objects = measure_objects[0]["json_object"]["values"]
        self.db_connection.insert_data(measure_objects, "measures_iso_27002")

    def load_measures_to_risks_mapping(self):
        mapped_items = []

        raw_text = self.__load_raw_data("https://raw.githubusercontent.com/monarc-project/MonarcAppFO/master/db-bootstrap/monarc_data.sql",
                                        r"measures_amvs`\s+VALUES\s+([^;]+)\);")
        raw_text_parts = re.split(r'\),\(', raw_text)
        for raw_text_part in raw_text_parts:
            values = raw_text_part.split(",")
            measure_id = values[1].replace("'", "")
            risk_id = values[-1].replace("'", "")
            mapped_items.append({"measure_id": measure_id, "risk_id": risk_id})

        self.db_connection.insert_data(mapped_items, "measures_risks_map")

    def __load_mosp_api_data(self, params, headers):
        params.update({"per_page": 5000})
        objects = requests.get("https://objects.monarc.lu/api/v2/object", params, headers=headers).json()

        return objects

    def __load_raw_data(self, url: str, regexp_str: str):
        raw_data = requests.get(url).text
        raw_text = re.search(regexp_str, raw_data).group(1)

        return raw_text

    def decide_and_returnd_data(self):
        """
        Checks if risk management data are already present in DB, if yes,
        just return them in needed format, if not, load them first and then
        return.
        """
        if not self.db_connection.get_data("assets"):
            self.load_assets()
            self.load_risks()
            self.load_measures()
            self.load_measures_to_risks_mapping()

        # TODO: transform data into dict with correct format
        data_to_return = {}

        return data_to_return
