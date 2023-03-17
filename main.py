import topology_generator
from extractors import MacExtractor, IPExtractor, DeviceExtractor, DPExtractor
from path import Path
from modules.clients import MariaDBClient
import entities
import sys


def main():
    db_client = MariaDBClient()
    device_extractor = DeviceExtractor(db_client)
    devices = device_extractor.extract()

    relations = entities.RelationsContainer()
    if len(sys.argv) > 1 and sys.argv[1] == "custom":
        mac_extractor = MacExtractor(db_client, relations)
        mac_relations = mac_extractor.extract()

        ip_extractor = IPExtractor(db_client, mac_relations)
        relations = ip_extractor.extract()
    else:
        dp_extractor = DPExtractor(db_client, relations)
        relations = dp_extractor.extract()

    js_data_json = topology_generator.generate_js_data_json(devices, relations)
    path_data_json = topology_generator.generate_topology_data_json(devices, relations)
    topology_generator.create_js_data_file(js_data_json, "src/data.json")
    topology_generator.create_json_file(path_data_json, "data/topology_data.json")


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()
