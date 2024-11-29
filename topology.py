from extractors import DeviceExtractor, DPExtractor
from modules.clients import MariaDBClient
from modules import entities
import math
import json


class Topology:
    def __init__(self):
        self.topology_db_client = MariaDBClient("topology")
        self.librenms_db_client = MariaDBClient("librenms")

    def calculate_new_coords(self) -> dict:
        ALPHA = 0.030
        ITERATIONS = 1000
        FORCE_MAGNITUDE = 1000

        unfiltered_node_records = self.topology_db_client.get_data("nodes")
        if not unfiltered_node_records:
            return {"x": 0, "y": 0}

        # remove records that have [0, 0] coords
        node_records = []
        for record in unfiltered_node_records:
            if record["x_coord"] == 0 and record["y_coord"] == 0:
                continue
            node_records.append(record)

        # define starting [X, Y] as center of all nodes
        all_x_coords = []
        all_y_coords = []
        for record in node_records:
            all_x_coords.append(float(record["x_coord"]))
            all_y_coords.append(float(record["y_coord"]))

        new_x = sum(all_x_coords)/len(all_x_coords)
        new_y = sum(all_y_coords)/len(all_y_coords)

        for i in range(0, ITERATIONS):
            x_shift = 0
            y_shift = 0

            for node_record in node_records:
                neighbor_x = float(node_record["x_coord"])
                neighbor_y = float(node_record["y_coord"])

                x_diff = abs(new_x - neighbor_x)
                y_diff = abs(new_y - neighbor_y)

                distance = x_diff ** 2 + y_diff ** 2
                distance = math.sqrt(distance)

                repulsive_force = FORCE_MAGNITUDE / distance

                if new_x < neighbor_x:
                    x_shift -= repulsive_force * (x_diff / distance)
                else:
                    x_shift += repulsive_force * (x_diff / distance)

                if new_y < neighbor_y:
                    y_shift -= repulsive_force * (y_diff / distance)
                else:
                    y_shift += repulsive_force * (y_diff / distance)

            x_shift *= ALPHA
            y_shift *= ALPHA

            new_x += x_shift
            new_y += y_shift

        return {"x": new_x, "y": new_y}

    def add_device(self, device_data: dict):
        coord_dict = self.calculate_new_coords()

        topology_data = {"id": device_data["id"],
                         "type": device_data["type"],
                         "asset": device_data["asset"],
                         "confidentality_value": device_data["confidentality-value"],
                         "confidentality_values": device_data["confidentality-values"],
                         "integrity_value": device_data["integrity-value"],
                         "integrity_values": device_data["integrity-values"],
                         "availability_value": device_data["availability-value"],
                         "availability_values": device_data["availability-values"],
                         "x_coord": coord_dict["x"],
                         "y_coord": coord_dict["y"]}

        self.topology_db_client.insert_data([topology_data], "nodes")

        librenms_data = {"device_id": device_data["id"],
                         "sysName": device_data["name"],
                         "hardware": device_data["model"],
                         "os": device_data["os"],
                         "hostname": device_data["name"],
                         "status_reason": " ",
                         "type": device_data["type"]}

        self.librenms_db_client.insert_data([librenms_data], "devices")

        device_data.update(coord_dict)

        return device_data

    def update_uninitialized_coords(self):
        """Calculates X and Y coords for all nodes that currently
        have [0, 0] coords. Takes data from topology DB and saves
        it into the same DB."""
        nodes = self.topology_db_client.get_data("nodes", [("x_coord", 0), ("y_coord", 0)])
        for node in nodes:
            coords = self.calculate_new_coords()
            coords = {"x_coord": coords["x"], "y_coord": coords["y"]}
            self.topology_db_client.update_data("nodes", [coords], [("id", node["id"])])

    def load_topology_from_db(self) -> dict:
        nodes = self.topology_db_client.get_data("nodes")
        output = {"nodes": [], "links": []}

        for node in nodes:
            node_data = self.librenms_db_client.get_data("devices", [("device_id", node["id"])])[0]
            device_to_add = {"id": node["id"],
                             "name": node_data["sysName"],
                             "icon": node["type"],
                             "type": node["type"],
                             "os": node_data["os"],
                             "model": node_data["hardware"],
                             "asset": node["asset"],
                             "confidentalityValue": node["confidentality_value"],
                             "confidentalityValues": json.loads(node["confidentality_values"]),
                             "integrityValue": node["integrity_value"],
                             "integrityValues": json.loads(node["integrity_values"]),
                             "availabilityValue": node["availability_value"],
                             "availabilityValues": json.loads(node["availability_values"]),

                             "x": float(node["x_coord"]),
                             "y": float(node["y_coord"])}

            interfaces = {}

            for interface_data in self.librenms_db_client.get_data("ports", [("device_id", node["id"])]):
                port_id = interface_data["port_id"]
                status = interface_data["ifOperStatus"]
                mac_address = interface_data["ifPhysAddress"]
                ip_address = None
                ip_address_record = self.librenms_db_client.get_data("ipv4_addresses", [("port_id", port_id)])
                if ip_address_record:
                    ip_address = ip_address_record[0]["ipv4_address"]
                interface_string = f"{port_id}/{status}/{ip_address}/{mac_address}"
                interface_name = interface_data["ifName"]

                interfaces.update({interface_name: interface_string})

            device_to_add.update({"interfaces": interfaces})
            output["nodes"].append(device_to_add)

        relations = self.topology_db_client.get_data("relations")

        for relation in relations:
            if1_data = self.librenms_db_client.get_data("ports", [("port_id", relation["source_if"])])[0]
            if2_data = self.librenms_db_client.get_data("ports", [("port_id", relation["target_if"])])[0]
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

    def save_topology_to_db(self, devices: list, relations: entities.RelationsContainer):
        """Saves devices and their relations (extracted from libreNMS DB)
        into topology DB. The current state is that if the device or relation
        is already present in the DB, skip it. Overwriting could be achieved
        by simply deleting the topology DB. Devices can't be overwritten
        because of the X, Y attributes. Relations can be overwritten."""
        devices_data = []

        existing_devices = self.topology_db_client.get_data("nodes")
        existing_devices_ids = []
        for device_record in existing_devices:
            existing_devices_ids.append(device_record["id"])

        for device in devices:
            if device.device_id in existing_devices_ids:
                continue

            devices_data.append({"id": device.device_id,
                                 "type": device.device_type,
                                 "asset": device.asset,
                                 "confidentality_value": 0,
                                 "confidentality_values": [0],
                                 "integrity_value": 0,
                                 "integrity_values": [0],
                                 "availability_value": 0,
                                 "availability_values": [0],
                                 })
        self.topology_db_client.insert_data(devices_data, "nodes")

        relations_data = []

        for index, relation in enumerate(relations):
            relations_data.append({"id": index,
                                   "source": relation.interface1.device_id,
                                   "source_if": relation.interface1.port_id,
                                   "target": relation.interface2.device_id,
                                   "target_if": relation.interface2.port_id})
        self.topology_db_client.insert_data(relations_data, "relations")

    def create_topology(self):
        """Forces algorithm to create topology - transform data from
        librenms DB into topology DB. Should also work to not only
        create topology data from scratch, but add missing/new data."""
        device_extractor = DeviceExtractor(self.librenms_db_client)
        devices = device_extractor.extract()

        relations = entities.RelationsContainer()

        # custom algorithm #
        # mac_extractor = MacExtractor(librenms_db_client, relations)
        # mac_relations = mac_extractor.extract()
        # ip_extractor = IPExtractor(librenms_db_client, mac_relations)
        # relations = ip_extractor.extract()

        # DP algorithm #
        dp_extractor = DPExtractor(self.librenms_db_client, relations)
        relations = dp_extractor.extract()

        self.save_topology_to_db(devices, relations)

    def get_topology_data(self, force_layout: bool) -> dict:
        topology_data = self.load_topology_from_db()
        # set data processor
        if force_layout:
            topology_data["dataProcessor"] = "force"
        else:
            topology_data["dataProcessor"] = "none"

        return topology_data

    def decide_and_return_topology(self) -> dict:
        """To be used on API endpoint when responding to frontend request.
        Decides whether it should force DP algorithm or just return data."""
        force_layout = False
        if not self.topology_db_client.get_data("nodes"):
            self.create_topology()
            force_layout = True
        return self.get_topology_data(force_layout)

    def topology_update(self, data: dict) -> None:
        for table_name, records in data.items():
            for record_id, record_value in records.items():
                self.topology_db_client.update_data(table_name, [record_value], [("id", record_id)])
