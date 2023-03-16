import topology_generator
from extractors import MacExtractor, IPExtractor, DeviceExtractor, DPExtractor
from modules.clients import MariaDBClient
import entities
import sys

from entities import Device, RelationsContainer
from modules.clients import MariaDBClient
from modules.exceptions import NotFoundError, MultipleOccurrences, PathNotFound

from ipaddress import IPv4Interface


class Path:
    def __init__(self, db_client: MariaDBClient, devices: list, relations: RelationsContainer):
        self.db_client = db_client

        self.devices = devices
        self.relations = relations

    def __get_port_id(self, ip_address: str) -> int:
        records = self.db_client.get_data("ipv4_addresses", [("ipv4_address", ip_address)])
        if not records:
            raise NotFoundError("ERROR: No interfaces with given IP address were found...")
        if len(records) > 1:
            raise MultipleOccurrences("ERROR: Multiple interfaces were found with given IP address - maybe it's"
                                      "a loopback address?")

        port_id = records[0]["port_id"]

        return port_id

    def __get_device_id_from_ip(self, ip_address: str) -> int:
        records = self.db_client.get_data("ipv4_addresses", [("ipv4_address", ip_address)])
        if not records:
            raise NotFoundError("ERROR: No interfaces with given IP address were found...")
        if len(records) > 1:
            raise MultipleOccurrences("ERROR: Multiple interfaces were found with given IP address - maybe it's"
                                      "a loopback address?")

        port_id = records[0]["port_id"]
        device_id = self.db_client.get_data("ports", [("port_id", port_id)])[0]["device_id"]

        return device_id

    def __has_routing_capabilities(self, device_id):
        for device in self.devices:
            if device.device_id == device_id:
                if device.device_type == "router":
                    return True
                break

        return False

    def __has_switching_capabilities(self, device_id):
        records = self.db_client.get_data("ports_fdb", [("device_id", device_id)])
        if records:
            return True
        return False

    def __get_target_network(self, ip_address):
        ip_record = self.db_client.get_data("ipv4_addresses", [("ipv4_address", ip_address)])[0]
        network_id = ip_record["ipv4_network_id"]
        network_record = self.db_client.get_data("ipv4_networks", [("ipv4_network_id", network_id)])[0]
        network = network_record["ipv4_network"]

        return network

    def __get_network_id(self, network: str):
        network_record = self.db_client.get_data("ipv4_networks", [("ipv4_network", network)])[0]
        network_id = network_record["ipv4_network_id"]

        return network_id

    def __get_default_gateway(self, device_id: int, network: str, forbidden_device_ids: list) -> dict:
        route_records = self.db_client.get_data("route", [("device_id", device_id), ("inetCidrRouteDest", "0.0.0.0")])
        if route_records:
            nexthop = route_records[0]["inetCidrRouteNextHop"]
            nexthop_addresses_records = self.db_client.get_data("ipv4_addresses", [("ipv4_address", nexthop)])
            if nexthop_addresses_records:
                port_id = nexthop_addresses_records[0]["port_id"]
                device_id = self.__get_device_id_from_port(port_id)
                if device_id:
                    return {"device_id": device_id, "port_id": port_id}

        network_id = self.__get_network_id(network)
        result = None

        addresses_records = self.db_client.get_data("ipv4_addresses", [("ipv4_network_id", network_id)])
        for record in addresses_records:
            port_id = record["port_id"]
            #device_id = self.db_client.get_data("ports", [("port_id", port_id)])[0]["device_id"]
            device_id = self.__get_device_id_from_port(port_id)
            if self.__has_routing_capabilities(device_id) and device_id not in forbidden_device_ids:
                result = {"device_id": device_id, "port_id": port_id}
                break
        return result

    def __get_mac_from_port_id(self, port_id):
        return self.db_client.get_data("ports", [("port_id", port_id)])[0]["ifPhysAddress"]

    def __get_device_id_from_port(self, port_id):
        record = self.db_client.get_data("ports", [("port_id", port_id)])
        if not record:
            return None
        return record[0]["device_id"]

    def __find_path(self, source_port_id: int, destination_port_id: int, path: RelationsContainer):
        relations = []

        if source_port_id == destination_port_id:
            return

        destination_mac = self.db_client.get_data("ports", [("port_id", destination_port_id)])[0]["ifPhysAddress"]
        source_mac = self.db_client.get_data("ports", [("port_id", source_port_id)])[0]["ifPhysAddress"]

        source_vlan = self.db_client.get_data("ports", [("port_id", source_port_id)])[0]["ifVlan"]

        initial_relation = self.relations.find(source_mac, source_port_id)
        if not initial_relation:
            source_device_id = self.__get_device_id_from_port(source_port_id)
            if not self.__has_switching_capabilities(source_device_id):
                return
            # if source is switch, there is no need to search for opposing device
            # also fixes problem when source is switch virtual interface
            opposing_device_id = source_device_id
        else:
            initial_opposing_interface = initial_relation.get_opposing_interface(source_mac, source_port_id)
            if initial_relation not in path:
                relations.append(initial_relation)

            if (destination_mac and initial_opposing_interface.mac_address == destination_mac) or (initial_opposing_interface.port_id == destination_port_id):
                path.add(initial_relation)
                return

            opposing_device_id = initial_opposing_interface.device_id

        while True:
            args = [("device_id", opposing_device_id), ]
            if destination_mac:
                args.append(("mac_address", destination_mac))
            else:
                args.append(("port_id", destination_port_id))
            if source_vlan:
                mac_record_vlan = self.db_client.get_data("vlans", [("device_id", opposing_device_id),
                                                                ("vlan_vlan", source_vlan)])[0]["vlan_id"]
                args.append(("vlan_id", mac_record_vlan))
            mac_records = self.db_client.get_data("ports_fdb", args)

            if not mac_records:
                raise PathNotFound("Could not find path - mac table does not have needed record")
            mac_record = mac_records[0]
            local_source_port_id = mac_record["port_id"]
            local_source_mac = self.__get_mac_from_port_id(local_source_port_id)
            local_relation = self.relations.find(local_source_mac, local_source_port_id)
            relations.append(local_relation)
            local_destination_port_id = local_relation.get_opposing_interface(local_source_mac, local_source_port_id).port_id
            local_destination_mac = local_relation.get_opposing_interface(local_source_mac, local_source_port_id).mac_address

            if (local_destination_mac and destination_mac and local_destination_mac == destination_mac) or (local_destination_port_id == destination_port_id):
                for relation in relations:
                    path.add(relation)
                return

            opposing_device_id = self.db_client.get_data("ports", [("port_id", local_destination_port_id)])[0]["device_id"]

    def __get_new_network(self, destination_network: str, device_id: int) -> dict:
        destination_network = destination_network.split("/")[0]
        destination_record = self.db_client.get_data("route", [("inetCidrRouteDest", destination_network), ("device_id", device_id)])
        if not destination_record:
            raise PathNotFound("Could not find path - routing table does not have needed record")
        destination_record = destination_record[0]

        source_port_id = destination_record["port_id"]
        nexthop = destination_record["inetCidrRouteNextHop"]
        destination_port_id = None

        if nexthop == "0.0.0.0":
            new_network = destination_network
        else:
            destination_port_id = self.__get_port_id(nexthop)
            address_record = self.db_client.get_data("ipv4_addresses", [("ipv4_address", nexthop)])[0]
            network_id = address_record["ipv4_network_id"]
            network_record = self.db_client.get_data("ipv4_networks", [("ipv4_network_id", network_id)])[0]
            new_network = network_record["ipv4_network"]

        return {"source_port_id": source_port_id, "destination_port_id": destination_port_id, "network": new_network}

    def get_path(self, source: str, destination: str) -> RelationsContainer:
        """Returns new RelationsContainer containing only relations that belong to path from source to destination.
        Source and destination must be in format 'ip_address' of devices or interfaces. For example 192.168.1.1."""
        path = RelationsContainer()

        source_port_id = self.__get_port_id(source)
        destination_port_id = self.__get_port_id(destination)
        source_device_id = self.__get_device_id_from_ip(source)
        destination_device_id = self.__get_device_id_from_ip(destination)
        source_mac = self.__get_mac_from_port_id(source_port_id)

        # check whether devices are not in direct relation
        initial_relation = self.relations.find_by_port_id(source_port_id)
        if initial_relation:
            initial_opposing_interface = initial_relation.get_opposing_interface(source_mac, source_port_id)
            path.add(initial_relation)
            if initial_opposing_interface.device_id == destination_device_id:
                return path

        current_network = str(IPv4Interface(source).network)
        forbidden_device_ids = [source_device_id]
        local_source_port_id = source_port_id
        local_destination_port_id = destination_port_id

        # check whether devices are in different networks
        same_network = False

        source_network = self.__get_target_network(source)
        destination_network = self.__get_target_network(destination)

        if source_network == destination_network:
            same_network = True

        guess_gateway = False
        if not same_network:
            guess_gateway = True

        # check if source device has routing capabilities - no need to guess gateway
        if guess_gateway:
            if self.__has_routing_capabilities(source_device_id):
                guess_gateway = False
                local_destination_port_id = local_source_port_id

        while True:
            if guess_gateway:
                local_destination = self.__get_default_gateway(source_device_id, str(current_network), forbidden_device_ids)
                if not local_destination:
                    raise PathNotFound("Could not find path - guessing starting point gateways was exhausted")
                local_destination_port_id = local_destination["port_id"]

            try:
                self.__find_path(local_source_port_id, local_destination_port_id, path)
            except PathNotFound:
                if guess_gateway:
                    forbidden_device_ids.append(local_destination["device_id"])
                    continue
                raise
            if same_network:
                break
            guess_gateway = False

            local_destination_device_id = self.db_client.get_data("ports", [("port_id", local_destination_port_id)])[0]["device_id"]
            new_network = self.__get_new_network(str(destination_network), local_destination_device_id)
            current_network = new_network["network"]
            if current_network == str(destination_network).split("/")[0]:
                same_network = True
                local_destination_port_id = destination_port_id
            else:
                local_destination_port_id = new_network["destination_port_id"]
            local_source_port_id = new_network["source_port_id"]

        return path


def main(source, destination, cost, color):
    db_client = MariaDBClient()
    device_extractor = DeviceExtractor(db_client)
    devices = device_extractor.extract()

    relations = entities.RelationsContainer()
    dp_extractor = DPExtractor(db_client, relations)
    relations = dp_extractor.extract()

    path = Path(db_client, devices, relations)

    single_path = path.get_path(source, destination)
    path_dict = {"relations": single_path, "color": color, "cost": cost}

    json = topology_generator.generate_path_json(path_dict)

    # TODO: pridavanie cost zariadeniam

    return json
