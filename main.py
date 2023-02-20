import topology_generator
from extractors import MacExtractor, IPExtractor, DeviceExtractor, DPExtractor
from modules.clients import MariaDBClient
import entities
import sys


def main():
    db_client = MariaDBClient()
    device_extractor = DeviceExtractor(db_client)
    devices = device_extractor.extract()

    relations = entities.RelationsContainer()
    if sys.argv[1] == "dp":
        dp_extractor = DPExtractor(db_client, relations)
        relations = dp_extractor.extract()
    elif sys.argv[1] == "algorithm":
        mac_extractor = MacExtractor(db_client, relations)
        mac_relations = mac_extractor.extract()

        ip_extractor = IPExtractor(db_client, mac_relations)
        relations = ip_extractor.extract()

    json = topology_generator.generate_json(devices, relations)
    topology_generator.generate_js_file(json)


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()
