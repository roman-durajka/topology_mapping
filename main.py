from extractors import MacExtractor, IPExtractor, DeviceExtractor, DPExtractor
from modules.clients import MariaDBClient
from modules import entities, topology_generator, asset_mapper
import sys


def main():
    topology_db_client = MariaDBClient("librenms")
    device_extractor = DeviceExtractor(topology_db_client)
    devices = device_extractor.extract()

    risk_mgmt_db_client = MariaDBClient("risk_management")

    # TODO: integrate into UI when it's done
    #data_load = DataLoader(risk_mgmt_db_client)
    #data_load.load_assets()
    #data_load.load_risks()
    #data_load.load_measures()
    #data_load.load_measures_to_risks_mapping()

    asset_map = asset_mapper.AssetMapper(risk_mgmt_db_client)
    asset_map.assign_risks_to_devices(devices)

    relations = entities.RelationsContainer()
    if len(sys.argv) > 1 and sys.argv[1] == "custom":  # uses custom algorithm if argument "custom" is specified
        mac_extractor = MacExtractor(topology_db_client, relations)
        mac_relations = mac_extractor.extract()

        ip_extractor = IPExtractor(topology_db_client, mac_relations)
        relations = ip_extractor.extract()
    else:  # uses discovery protocols algorithm if nothing else is specified
        dp_extractor = DPExtractor(topology_db_client, relations)
        relations = dp_extractor.extract()

    js_data_json = topology_generator.generate_js_data_json(devices, relations)
    path_data_json = topology_generator.generate_topology_data_json(devices, relations)
    # topology_generator.create_js_data_file(js_data_json, "./src/data.js")  # write js topology data to file
    topology_generator.create_json_file(path_data_json, "./data/topology_data.json")

    return js_data_json


if __name__ == '__main__':
    main()
