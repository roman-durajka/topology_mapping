from modules.entities import RelationsContainer
import json


def generate_js_data_json(devices: list, relations: RelationsContainer) -> dict:
    """
    Generates output used by javascript code to create and load topology.
    :param devices: devices to be used in topology as nodes
    :param relations: relations to be used in topology as links
    :return: dict
    """
    output = {"nodes": [], "links": []}

    for device in devices:
        device_to_add = {"id": device.device_id,
                         "name": device.name,
                         "icon": device.device_type,
                         "type": device.device_type,
                         "os": device.os,
                         "model": device.model,
                         "asset-value": 0,
                         "asset-values": [0]}

        interfaces = {}
        for key, value in device.interfaces.items():
            interface_string = f"{value['status']}/{value['ip_address']}/{value['mac_address']}"
            interfaces.update({value["name"]: interface_string})
        device_to_add.update({"interfaces": interfaces})

        output["nodes"].append(device_to_add)

    for index, relation in enumerate(relations):
        relation_to_add = {"id": index,
                           "source": relation.interface1.device_id,
                           "target": relation.interface2.device_id,
                           "srcIfName": relation.interface1.interface_name,
                           "tgtIfName": relation.interface2.interface_name,
                           "srcMac": relation.interface1.mac_address,
                           "tgtMac": relation.interface2.mac_address}

        output["links"].append(relation_to_add)

    return output


def generate_js_path_data_json(path: RelationsContainer, color: str, starting_index: int) -> dict:
    """
    Generates output used by javascript code to create path.
    :param path: RelationsContainer object containing relations that represent path
    :param color: color of path to be drawn in
    :param starting_index: index to start with, can't overlap with already existing links/relations in topology
    :return: dict
    """
    output = {"links": [], "nodes": []}

    index = starting_index
    for relation in path:
        relation_to_add = {"id": index,
                           "source": relation.interface1.device_id,
                           "target": relation.interface2.device_id,
                           "srcIfName": relation.interface1.interface_name,
                           "tgtIfName": relation.interface2.interface_name,
                           "srcMac": relation.interface1.mac_address,
                           "tgtMac": relation.interface2.mac_address,
                           "color": color,
                           "width": 2,
                           "dotted": True}
        output["links"].append(relation_to_add)
        index += 1

        for device_id in [relation.interface1.device_id,
                          relation.interface2.device_id]:
            if device_id not in output["nodes"]:
                output["nodes"].append(device_id)

    return output


def generate_topology_data_json(devices: list, relations: RelationsContainer) -> dict:
    """
    Generates output used by path algorithm to create path.
    :param devices: devices in path
    :param relations: relations/links in path
    :return: dict
    """
    output = {
        "devices": [device.asdict() for device in devices],
        "relations": [relation.asdict() for relation in relations]
    }

    return output


def create_json_file(topology_json: dict, filename: str):
    """
    Generates file in json format.
    :param topology_json: data in json format to be written into file
    :param filename: name of file
    """
    file_to_write = open(filename, "w")
    file_to_write.write(f"{json.dumps(topology_json, indent=4, sort_keys=True)}")
    file_to_write.close()


def create_js_data_file(topology_json: dict, filename: str):
    """
    Generates file in js format. Data are written to a variable in js language.
    :param topology_json: data in json format to be written into file/js variable
    :param filename: name of file
    """
    file_to_write = open(filename, "w")
    file_to_write.write(f"var topologyData={json.dumps(topology_json, indent=4, sort_keys=True)};")
    file_to_write.close()
