from entities import RelationsContainer
import json


def generate_json(devices: list, relations: RelationsContainer):
    output = {"nodes": [], "links": []}

    for device in devices:
        device_to_add = {"id": device.device_id,
                         "name": device.name}

        if "sw" in device.name or device.os == "junos":
            icon = "switch"
        elif device.os in ["ios", "fortigate"]:
            icon = "router"
        else:
            icon = "host"
        device_to_add["icon"] = icon

        output["nodes"].append(device_to_add)

    for index, relation in enumerate(relations):
        relation_to_add = {"id": index + 1,
                           "source": relation.interface1.device_id,
                           "target": relation.interface2.device_id,
                           "srcIfName": relation.interface1.interface_name,
                           "tgtIfName": relation.interface2.interface_name}

        output["links"].append(relation_to_add)

    return output


def generate_js_file(topology_json: dict):
    file_to_write = open("topology/data.js", "w")
    file_to_write.write(f"var topologyData={json.dumps(topology_json, indent=4, sort_keys=True)};")
    file_to_write.close()
