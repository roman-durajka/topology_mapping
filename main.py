from extractors import MacExtractor, IPExtractor, DeviceExtractor
from modules.clients import MariaDBClient


def main():
    db_client = MariaDBClient()
    mac_extractor = MacExtractor(db_client)
    ip_extractor = IPExtractor(db_client)
    device_extractor = DeviceExtractor(db_client)

    devices = device_extractor.extract()
    mac_relations = mac_extractor.extract()
    ip_relations = ip_extractor.extract()

    relations = f"{mac_relations}\n{ip_relations}"

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
