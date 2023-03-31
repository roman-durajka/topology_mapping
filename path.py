from modules import topology_generator
from modules.entities import RelationsContainer, load_entities
from modules.clients import MariaDBClient
from modules.exceptions import NotFoundError, MultipleOccurrences, PathNotFound

from ipaddress import IPv4Interface
import json


class Path:
    """Class for finding path from source to destination"""
    def __init__(self, db_client: MariaDBClient, devices: list, relations: RelationsContainer):
        self.db_client = db_client

        self.devices = devices
        self.relations = relations

    def __get_port_id(self, ip_address: str) -> int:
        """
        Returns port id based on ip address
        :param ip_address: ip address of interface to get id of
        :return: int port id
        """
        records = self.db_client.get_data("ipv4_addresses", [("ipv4_address", ip_address)])
        if not records:
            raise NotFoundError("ERROR: No interfaces with given IP address were found...")
        if len(records) > 1:
            raise MultipleOccurrences("ERROR: Multiple interfaces were found with given IP address - maybe it's"
                                      "a loopback address?")

        port_id = records[0]["port_id"]

        return port_id

    def __get_device_id_from_ip(self, ip_address: str) -> int:
        """
        Returns device id based on ip address
        :param ip_address: ip address of one of devices interfaces
        :return: int device id
        """
        port_id = self.__get_port_id(ip_address)
        device_id = self.db_client.get_data("ports", [("port_id", port_id)])[0]["device_id"]

        return device_id

    def __has_routing_capabilities(self, device_id: int) -> bool:
        """
        Determines whether a device has routing capabilities based on its id. Checks if device type is router or not.
        :param device_id: id of device
        :return: bool
        """
        for device in self.devices:
            if device.device_id == device_id:
                if device.device_type == "router":
                    return True
                break

        return False

    def __has_switching_capabilities(self, device_id: int) -> bool:
        """
        Determines whether a device has routing capabilities based on its id. Checks if device is present in any of
        MAC tables.
        :param device_id: id of device
        :return: bool
        """
        records = self.db_client.get_data("ports_fdb", [("device_id", device_id)])
        if records:
            return True
        return False

    def __get_target_network(self, ip_address: str) -> str:
        """
        Returns network to which given ip address belongs to.
        :param ip_address: ip address to find network of
        :return: network
        """
        ip_record = self.db_client.get_data("ipv4_addresses", [("ipv4_address", ip_address)])[0]
        network_id = ip_record["ipv4_network_id"]
        network_record = self.db_client.get_data("ipv4_networks", [("ipv4_network_id", network_id)])[0]
        network = network_record["ipv4_network"]

        return network

    def __get_network_id(self, network: str) -> int:
        """
        Returns network id of given network.
        :param network: network address to get id of
        :return: id of network
        """
        network_record = self.db_client.get_data("ipv4_networks", [("ipv4_network", network)])[0]
        network_id = network_record["ipv4_network_id"]

        return network_id

    def __get_default_gateway(self, device_id: int, network: str, forbidden_device_ids: list) -> dict:
        """
        Tries to find default gateway address in routing tables. If no address is found or address is invalid, uses
        heuristic to guess valid default gateway address.
        :param device_id: id of device to find default gateway of
        :param network: network to which device to find default gateway of belongs
        :param forbidden_device_ids: device ids of possible default gateways that should not be used during heuristic
        algorithm
        :return:
        """
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
            device_id = self.__get_device_id_from_port(port_id)
            if self.__has_routing_capabilities(device_id) and device_id not in forbidden_device_ids:
                result = {"device_id": device_id, "port_id": port_id}
                break
        return result

    def __get_mac_from_port_id(self, port_id: int) -> str:
        """
        Returns MAC address of interface based on its id.
        :param port_id: id of interface
        :return: MAC address
        """
        return self.db_client.get_data("ports", [("port_id", port_id)])[0]["ifPhysAddress"]

    def __get_device_id_from_port(self, port_id: int) -> int:
        """
        Returns id of device based on id of one of its interfaces
        :param port_id: id of one of devices interface
        :return: device id
        """
        record = self.db_client.get_data("ports", [("port_id", port_id)])
        if not record:
            return None
        return record[0]["device_id"]

    def __find_path(self, source_port_id: int, destination_port_id: int, path: RelationsContainer):
        """
        Attempts to find path inside local network based on MAC table records. Source (fe. host) and destination (fe.
        default gateway) have to be specified. Uses already established and found relations by another algorithm
        to create path.
        :param source_port_id: id of source interface
        :param destination_port_id: id of target interface
        :param path: RelationsContainer object to save path into
        :return:
        """
        relations = []

        if source_port_id == destination_port_id:  # device could already be default gateway
            return

        destination_mac = self.db_client.get_data("ports", [("port_id", destination_port_id)])[0]["ifPhysAddress"]
        source_mac = self.db_client.get_data("ports", [("port_id", source_port_id)])[0]["ifPhysAddress"]

        source_vlan = self.db_client.get_data("ports", [("port_id", source_port_id)])[0]["ifVlan"]

        # if source is host, find initial relation and continue algorithm with neighboring switch data
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
                # before continuing with switch data, add relation between host and switch to path
                relations.append(initial_relation)

            # if opposing device is already destination (in local network), there is nothing to look for anymore
            if (destination_mac and initial_opposing_interface.mac_address == destination_mac) or (initial_opposing_interface.port_id == destination_port_id):
                path.add(initial_relation)
                return

            opposing_device_id = initial_opposing_interface.device_id

        # start algorithm based on MAC tables
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

            # relation to next device was found, so get required data and check if it's not destination
            mac_record = mac_records[0]
            local_source_port_id = mac_record["port_id"]
            local_source_mac = self.__get_mac_from_port_id(local_source_port_id)
            local_relation = self.relations.find(local_source_mac, local_source_port_id)
            relations.append(local_relation)
            local_destination_port_id = local_relation.get_opposing_interface(local_source_mac, local_source_port_id).port_id
            local_destination_mac = local_relation.get_opposing_interface(local_source_mac, local_source_port_id).mac_address

            # if found device is destination, definitely add relations to path and end algorithm
            if (local_destination_mac and destination_mac and local_destination_mac == destination_mac) or (local_destination_port_id == destination_port_id):
                for relation in relations:
                    path.add(relation)
                return

            opposing_device_id = self.db_client.get_data("ports", [("port_id", local_destination_port_id)])[0]["device_id"]

    def __get_new_network(self, destination_network: str, device_id: int) -> dict:
        """
        Find and return first network between device and destination network based on routing table records. If
        next hop == 0.0.0.0, found network IS destination network.
        :param destination_network: destination network
        :param device_id: device id of router on which routing records should be searched
        :return: dict containing new network and source/destination interface ids in this network
        """
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
        """
        Returns new RelationsContainer containing only relations that belong to path from source to destination.
        Source and destination must be in format 'ip_address' of devices or interfaces. For example 192.168.1.1.
        :param source: source ip address, eg. 192.168.1.1
        :param destination: destination ip address, eg. 192.168.2.1
        :return: RelationsContainer object containing path
        """
        path = RelationsContainer()

        source_port_id = self.__get_port_id(source)
        destination_port_id = self.__get_port_id(destination)
        source_device_id = self.__get_device_id_from_ip(source)
        destination_device_id = self.__get_device_id_from_ip(destination)
        source_mac = self.__get_mac_from_port_id(source_port_id)

        # check whether devices are not in direct relation
        initial_relation = self.relations.find("", source_port_id)
        if initial_relation:
            initial_opposing_interface = initial_relation.get_opposing_interface(source_mac, source_port_id)
            if initial_opposing_interface.device_id == destination_device_id:
                path.add(initial_relation)
                return path

        current_network_id = self.db_client.get_data("ipv4_addresses", [("ipv4_address", source)])[0]["ipv4_network_id"]
        current_network = self.db_client.get_data("ipv4_networks", [("ipv4_network_id", current_network_id)])[0]["ipv4_network"]
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

        # firstly find path through local network by searching MAC tables, then find new network by searching routing tables
        # repeat until destination network and destination device is obtained
        while True:
            # if devices are not in the same network, find default gateway
            if guess_gateway:
                local_destination = self.__get_default_gateway(source_device_id, str(current_network), forbidden_device_ids)
                if not local_destination:
                    raise PathNotFound("Could not find path - guessing starting point gateways was exhausted")
                local_destination_port_id = local_destination["port_id"]

            # find path inside local network
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

            # update local variables so algorithm can continue in new network
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


def main(req_json):
    """Function to find path fired from one of API endpoints."""
    db_client = MariaDBClient()

    file_to_read = open("data/topology_data.json", "r")
    file_data = file_to_read.read()
    file_to_read.close()
    json_data = json.loads(file_data)
    devices, relations_container = load_entities(json_data)

    source = req_json["source"]
    destination = req_json["target"]
    color = req_json["color"]
    starting_index = req_json["startingIndex"]

    path_obj = Path(db_client, devices, relations_container)
    path = path_obj.get_path(source, destination)

    path_json = topology_generator.generate_js_path_data_json(path, color, starting_index)

    return path_json
