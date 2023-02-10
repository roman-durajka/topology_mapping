from extractors import MacExtractor, IPExtractor, DeviceExtractor, DPExtractor
from modules.clients import MariaDBClient


def main():
    db_client = MariaDBClient()
    device_extractor = DeviceExtractor(db_client)
    devices = device_extractor.extract()

    mac_extractor = MacExtractor(db_client)
    mac_relations = mac_extractor.extract()

    ip_extractor = IPExtractor(db_client, mac_relations)
    ip_relations = ip_extractor.extract()
    #TODO: COMMAND LINE ARGUMENT TO FORCE CDP/LLDP ONLY ip_relations = entities.RelationsContainer()
    dp_extractor = DPExtractor(db_client, ip_relations)
    dp_relations = dp_extractor.extract()

    relations = f"{dp_relations}"

    file_to_write = open("graph_example.dot", "w")
    file_to_write.write("graph G {\n")

    file_to_write.write(devices)
    file_to_write.write("\n")
    file_to_write.write(relations)

    file_to_write.write("}")

    file_to_write.close()


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()
