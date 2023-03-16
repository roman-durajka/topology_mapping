import random

from entities import RelationsContainer
import json


def generate_json(devices: list, relations: RelationsContainer):
    output = {"nodes": [], "links": [], "paths": []}

    for device in devices:
        device_to_add = {"id": device.device_id,
                         "name": device.name,
                         "icon": device.device_type,
                         "type": device.device_type,
                         "os": device.os,
                         "model": device.model,
                         "cost": 0}

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


def generate_path_json(path: dict):
    output = {"paths": [], "links": [], "nodes": []}

    index = random.Random().randint(500, 50000)
    color = path["color"]
    cost = path["cost"]
    first_relation = True
    path_id = random.Random().randint(200, 50000)
    for relation in path["relations"]:
        relation_to_add = {"id": random.Random().randint(500, 10000),
                           "source": relation.interface1.device_id,
                           "target": relation.interface2.device_id,
                           "srcIfName": relation.interface1.interface_name,
                           "tgtIfName": relation.interface2.interface_name,
                           "srcMac": relation.interface1.mac_address,
                           "tgtMac": relation.interface2.mac_address,
                           "color": color,
                           "cost": cost,
                           "width": 2,
                           "dotted": True,
                           "pathId": path_id}

        if first_relation:
            first_relation = False
            output["paths"].append({"color": color, "cost": cost})

        output["links"].append(relation_to_add)

        for device in output["nodes"]:
            if relation.interface1.device_id == device["id"] \
                    or relation.interface2.device_id == device["id"]:
                if "cost" in device:
                    if device["cost"] < cost:
                        device["cost"] = cost
                else:
                    device["cost"] = cost

        index += 1

    return output


def generate_js_file(topology_json: dict):
    file_to_write = open("src/data.js", "w")
    file_to_write.write(f"var topologyData={json.dumps(topology_json, indent=4, sort_keys=True)};")
    file_to_write.close()


def generate_json_file(topology_json: dict):
    file_to_write = open("topology/topology_data.json", "w")
    file_to_write.write(f"{json.dumps(topology_json, indent=4, sort_keys=True)};")
    file_to_write.close()
