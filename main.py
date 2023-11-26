from extractors import MacExtractor, IPExtractor, DeviceExtractor, DPExtractor
from modules.clients import MariaDBClient
from modules import entities, topology_generator, asset_mapper
import sys


def add_device(req_json: dict):
    topology_db_client = MariaDBClient("topology")
    librenms_db_client = MariaDBClient("librenms")

    topology_data = {"id": req_json["id"],
                     "type": req_json["type"],
                     "asset": req_json["asset"],
                     "asset_value": req_json["asset-value"],
                     "asset_values": req_json["asset-values"]}

    topology_db_client.insert_data([topology_data], "nodes")

    librenms_data = {"device_id": req_json["id"],
                     "sysName": req_json["name"],
                     "hardware": req_json["model"],
                     "os": req_json["os"],
                     "hostname": req_json["name"],
                     "status_reason": " "}

    librenms_db_client.insert_data([librenms_data], "devices")


def main():
    topology_db_client = MariaDBClient("topology")
    librenms_db_client = MariaDBClient("librenms")
    if topology_db_client.get_data("nodes"):
        js_data_json = topology_generator.load_topology_from_db(topology_db_client, librenms_db_client)

        return js_data_json

    device_extractor = DeviceExtractor(librenms_db_client)
    devices = device_extractor.extract()

    # TODO: integrate into UI when it's done
    #data_load = DataLoader(risk_mgmt_db_client)
    #data_load.load_assets()
    #data_load.load_risks()
    #data_load.load_measures()
    #data_load.load_measures_to_risks_mapping()

    relations = entities.RelationsContainer()
    if len(sys.argv) > 1 and sys.argv[1] == "custom":  # uses custom algorithm if argument "custom" is specified
        mac_extractor = MacExtractor(librenms_db_client, relations)
        mac_relations = mac_extractor.extract()

        ip_extractor = IPExtractor(librenms_db_client, mac_relations)
        relations = ip_extractor.extract()
    else:  # uses discovery protocols algorithm if nothing else is specified
        dp_extractor = DPExtractor(librenms_db_client, relations)
        relations = dp_extractor.extract()

    topology_generator.save_topology_to_db(devices, relations, topology_db_client)
    js_data_json = topology_generator.generate_js_data_json(devices, relations)
    #path_data_json = topology_generator.generate_topology_data_json(devices, relations)  # write topology to file for path module to read
    #topology_generator.create_json_file(path_data_json, "./data/topology_data.json")
    # topology_generator.create_js_data_file(js_data_json, "./src/data.next_ui")  # write next_ui topology data to file

    return js_data_json


if __name__ == '__main__':
    main()
