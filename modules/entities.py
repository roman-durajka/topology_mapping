import typing


class Interface:
    """Class representing interface on real device."""

    def __init__(self, interface_name: str, device_id: int, port_id: int, ip_address: str, mac_address: str,
                 trunk: bool):
        self.interface_name = interface_name
        self.device_id = device_id
        self.port_id = port_id

        self.ip_address = ip_address
        self.mac_address = mac_address

        self.trunk = trunk

    def asdict(self) -> dict:
        """
        Returns object attributes as dictionary.
        :return: dict
        """
        return {
            "interface_name": self.interface_name,
            "device_id": self.device_id,
            "port_id": self.port_id,
            "ip_address": self.ip_address,
            "mac_address": self.mac_address,
            "trunk": self.trunk
        }


class Relation:
    """Class representing relation between two interfaces."""

    def __init__(self, interface1: Interface, interface2: Interface):
        self.interface1 = interface1
        self.interface2 = interface2

    def __eq__(self, other):
        return sorted((self.interface1.device_id, self.interface2.device_id)) == sorted(
            (other.interface1.device_id, other.interface2.device_id)) and sorted(
            (self.interface1.port_id, self.interface2.port_id)) == sorted(
            (other.interface1.port_id, other.interface2.port_id))

    def get_opposing_interface(self, mac_address: str, port_id: int) -> Interface:
        """
        Returns interface opposing to known interface (or its data).
        :param mac_address: mac address of known interface
        :param port_id: interface id of know interface
        :return: Interface object of opposing interface
        """
        if (mac_address and self.interface1.mac_address == mac_address) or (self.interface1.port_id == port_id):
            return self.interface2
        return self.interface1

    def asdict(self) -> dict:
        """
        Returns object attributes as dictionary.
        :return: dict
        """
        return {
            "interface1": self.interface1.asdict(),
            "interface2": self.interface2.asdict()
        }


class RelationsContainer:
    """Class representing a container of interfaces. Has methods to make working with lots of interfaces easier."""

    def __init__(self):
        self.relations = []

    def __iter__(self):
        self.index = 0
        return self

    def __next__(self):
        if self.index == len(self.relations):
            raise StopIteration
        self.index += 1
        return self.relations[self.index - 1]

    def __len__(self):
        return len(self.relations)

    def add(self, relation: Relation):
        """
        Adds relation if it's unique.
        :param relation: Relation object to add
        """
        unique = True
        for existing_relation in self.relations:
            if relation == existing_relation:
                unique = False
                break

        if unique:
            self.relations.append(relation)

    def find(self, mac_address: str, port_id: int) -> Relation:
        """
        Finds and returns relation based on MAC address or interface id.
        :param mac_address: MAC address of interface
        :param port_id: id of interface
        :return: found Relation object, None if not found
        """
        criteria = mac_address
        if not mac_address:
            criteria = port_id

        found_relation = None
        for relation in self.relations:
            if mac_address:
                to_compare = [relation.interface1.mac_address, relation.interface2.mac_address]
            else:
                to_compare = [relation.interface1.port_id, relation.interface2.port_id]
            if criteria in to_compare:
                found_relation = relation
                break

        return found_relation


class Device:
    """Class representing real device."""

    def __init__(self, device_id, name, os, model, device_type, interfaces, asset):
        self.device_id = device_id
        self.name = name
        self.os = os
        self.model = model
        self.device_type = device_type
        self.asset = asset

        self.interfaces = interfaces
        self.vulnerabilities = []
        self.threats = []

    def asdict(self) -> dict:
        """
        Returns object attributes as dictionary.
        :return: dict
        """
        return {
            "device_id": self.device_id,
            "name": self.name,
            "os": self.os,
            "model": self.model,
            "device_type": self.device_type,
            "asset": self.asset,
            "interfaces": [{keyitem[0]: keyitem[1]} for keyitem in self.interfaces.items()]
        }


def load_entities_from_db(topology_db_client, librenms_db_client) -> typing.Tuple[list, RelationsContainer]:
    """
    Loads data from json into appropriate objects.
    """
    devices = []

    nodes = topology_db_client.get_data("nodes")

    for node in nodes:
        device_data = librenms_db_client.get_data("devices", [("device_id", node["id"])])[0]
        interfaces = []
        interfaces_data = librenms_db_client.get_data("ports", [("device_id", node["id"])])
        for interface in interfaces_data:
            interface_ip_record = librenms_db_client.get_data("ipv4_addresses", [("port_id", interface["port_id"])])
            interface_ip = None if not interface_ip_record else interface_ip_record[0]["ipv4_address"]
            interface_dict = {
                interface["port_id"]: {
                    "ip_address": interface_ip,
                    "mac_address": interface["ifPhysAddress"],
                    "name": interface["ifName"],
                    "status": interface["ifOperStatus"]
                }
            }
            interfaces.append(interface_dict)

        new_device = Device(
            node["id"],
            device_data["sysName"],
            device_data["os"],
            device_data["hardware"],
            node["type"],
            interfaces,
            node["asset"]
        )
        devices.append(new_device)

    relations_container = RelationsContainer()
    relations = topology_db_client.get_data("relations")

    for relation in relations:
        source_if_id = relation["source_if"]

        source_if_data = librenms_db_client.get_data("ports", [("port_id", source_if_id)])[0]
        source_if_ip_record = librenms_db_client.get_data("ipv4_addresses", [("port_id", source_if_id)])
        source_if_ip = None if not source_if_ip_record else source_if_ip_record[0]["ipv4_address"]

        source_trunk = True if source_if_data["ifTrunk"] else False

        if1 = Interface(
            source_if_data["ifName"],
            relation["source"],
            source_if_id,
            source_if_ip,
            source_if_data["ifPhysAddress"],
            source_trunk
        )

        target_if_id = relation["target_if"]

        target_if_data = librenms_db_client.get_data("ports", [("port_id", target_if_id)])[0]
        target_if_ip_record = librenms_db_client.get_data("ipv4_addresses", [("port_id", target_if_id)])
        target_if_ip = None if not target_if_ip_record else target_if_ip_record[0]["ipv4_address"]

        target_trunk = True if target_if_data["ifTrunk"] else False

        if2 = Interface(
            target_if_data["ifName"],
            relation["target"],
            target_if_id,
            target_if_ip,
            target_if_data["ifPhysAddress"],
            target_trunk
        )

        if_relation = Relation(if1, if2)
        relations_container.add(if_relation)

    return devices, relations_container
