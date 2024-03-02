from modules.entities import RelationsContainer, Interface, Relation
import json


def save_topology_to_db(devices: list, relations: RelationsContainer, db_client):
    devices_data = []
    for device in devices:
        devices_data.append({"id": device.device_id,
                             "type": device.device_type,
                             "asset": device.asset,
                             "asset_value": 0,
                             "asset_values": [0]})
    db_client.insert_data(devices_data, "nodes")

    relations_data = []
    for index, relation in enumerate(relations):
        relations_data.append({"id": index,
                               "source": relation.interface1.device_id,
                               "source_if": relation.interface1.port_id,
                               "target": relation.interface2.device_id,
                               "target_if": relation.interface2.port_id})
    db_client.insert_data(relations_data, "relations")


def load_topology_from_db(topology_db_client, librenms_db_client) -> dict:
    nodes = topology_db_client.get_data("nodes")
    output = {"nodes": [], "links": []}

    for node in nodes:
        node_data = librenms_db_client.get_data("devices", [("device_id", node["id"])])[0]
        device_to_add = {"id": node["id"],
                         "name": node_data["sysName"],
                         "icon": node["type"],
                         "type": node["type"],
                         "os": node_data["os"],
                         "model": node_data["hardware"],
                         "asset": node["asset"],
                         "asset-value": node["asset_value"],
                         "asset-values": json.loads(node["asset_values"])}

        interfaces = {}

        for interface_data in librenms_db_client.get_data("ports", [("device_id", node["id"])]):
            port_id = interface_data["port_id"]
            status = interface_data["ifOperStatus"]
            mac_address = interface_data["ifPhysAddress"]
            ip_address = None
            ip_address_record = librenms_db_client.get_data("ipv4_addresses", [("port_id", port_id)])
            if ip_address_record:
                ip_address = ip_address_record[0]["ipv4_address"]
            interface_string = f"{port_id}/{status}/{ip_address}/{mac_address}"
            interface_name = interface_data["ifName"]

            interfaces.update({interface_name: interface_string})

        device_to_add.update({"interfaces": interfaces})
        output["nodes"].append(device_to_add)

    relations = topology_db_client.get_data("relations")

    for relation in relations:
        if1_data = librenms_db_client.get_data("ports", [("port_id", relation["source_if"])])[0]
        if2_data = librenms_db_client.get_data("ports", [("port_id", relation["target_if"])])[0]
        relation_to_add = {"id": relation["id"],
                           "srcIfID": relation["source_if"],
                           "tgtIfID": relation["target_if"],
                           "source": relation["source"],
                           "target": relation["target"],
                           "srcIfName": if1_data["ifName"],
                           "tgtIfName": if2_data["ifName"],
                           "srcMac": if1_data["ifPhysAddress"],
                           "tgtMac": if2_data["ifPhysAddress"]}

        output["links"].append(relation_to_add)

    return output


def save_path_to_db(path: RelationsContainer, starting_index: int, color: str, asset_value: int, path_name: str, group_id: int, topology_db_client):
    path_relations = []

    for relation in path:
        relation_record = topology_db_client.get_data("relations", [("source_if", relation.interface1.port_id), ("target_if", relation.interface2.port_id)])[0]
        relation_id = relation_record["id"]

        relation_to_add = {"path_id": starting_index,
                           "relation_id": relation_id,
                           "color": color,
                           "asset_value": asset_value,
                           "name": path_name,
                           "application_group_id": group_id}

        path_relations.append(relation_to_add)

    topology_db_client.insert_data(path_relations, "paths")


def load_paths_from_db(topology_db_client, librenms_db_client) -> list:
    paths_records = topology_db_client.get_data("paths")

    path_ids = []
    for path_record in paths_records:
        if path_record["path_id"] not in path_ids:
            path_ids.append(path_record["path_id"])

    # {path: RelationsContainer, starting_index: ..., color: ...}
    paths = []

    for path_id in path_ids:
        path_container = RelationsContainer()
        color = ""
        asset_value = 0
        path_name = ""
        for path_record in paths_records:
            if path_record["path_id"] == path_id:
                relation_record = topology_db_client.get_data("relations", [("id", path_record["relation_id"])])[0]

                if not color:
                    color = path_record["color"]

                if asset_value == 0:
                    asset_value = path_record["asset_value"]

                if not path_name:
                    path_name = path_record["name"]

                # get all necessary source interface data
                source_if_id = relation_record["source_if"]
                source_interface_data = librenms_db_client.get_data("ports", [("port_id", source_if_id)])[0]
                source_interface_name = source_interface_data["ifName"]
                source_device_id = relation_record["source"]
                source_ip_address = None
                source_ip_address_record = librenms_db_client.get_data("ipv4_addresses",
                                                                [("port_id", source_interface_data["port_id"])])
                if source_ip_address_record:
                    source_ip_address = source_ip_address_record[0]["ipv4_address"]
                source_mac_address = source_interface_data["ifPhysAddress"]
                source_trunk = True if source_interface_data["ifTrunk"] else False

                source_interface = Interface(source_interface_name, source_device_id, source_if_id, source_ip_address, source_mac_address, source_trunk)

                # get all necessary target interface data
                target_if_id = relation_record["target_if"]
                target_interface_data = librenms_db_client.get_data("ports", [("port_id", target_if_id)])[0]
                target_interface_name = target_interface_data["ifName"]
                target_device_id = relation_record["target"]
                target_ip_address = None
                target_ip_address_record = librenms_db_client.get_data("ipv4_addresses",
                                                                       [("port_id", target_interface_data["port_id"])])
                if target_ip_address_record:
                    target_ip_address = target_ip_address_record[0]["ipv4_address"]
                target_mac_address = target_interface_data["ifPhysAddress"]
                target_trunk = True if target_interface_data["ifTrunk"] else False

                target_interface = Interface(target_interface_name, target_device_id, target_if_id, target_ip_address,
                                      target_mac_address, target_trunk)

                relation = Relation(source_interface, target_interface)
                path_container.add(relation)

        paths.append({"path": path_container, "starting_index": path_id, "color": color, "asset_value": asset_value, "name": path_name})
    return paths


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
                         "asset": device.asset,
                         "asset-value": 0,
                         "asset-values": [0]}

        interfaces = {}
        for key, value in device.interfaces.items():
            interface_string = f"{key}/{value['status']}/{value['ip_address']}/{value['mac_address']}"
            interfaces.update({value["name"]: interface_string})
        device_to_add.update({"interfaces": interfaces})

        if device.vulnerabilities:
            device_to_add.update({"vulnerabilities": device.vulnerabilities})

        if device.threats:
            device_to_add.update({"threats": device.threats})

        output["nodes"].append(device_to_add)

    for index, relation in enumerate(relations):
        relation_to_add = {"id": index,
                           "srcIfID": relation.interface1.port_id,
                           "tgtIfID": relation.interface2.port_id,
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
