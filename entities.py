class Interface:
    def __init__(self, interface_name: str, device_id: int, port_id: int, ip_address: str, mac_address: str,
                 trunk: bool):
        self.interface_name = interface_name
        self.device_id = device_id
        self.port_id = port_id
        self.ip_address = ip_address
        self.mac_address = mac_address
        self.trunk = trunk


class Relation:
    def __init__(self, interface1: Interface, interface2: Interface):
        self.interface1 = interface1
        self.interface2 = interface2

    def __eq__(self, other):
        return sorted((self.interface1.device_id, self.interface2.device_id)) == sorted(
            (other.interface1.device_id, other.interface2.device_id)) and sorted(
            (self.interface1.port_id, self.interface2.port_id)) == sorted(
            (other.interface1.port_id, other.interface2.port_id))

    def get_opposing_interface(self, mac_address: str, port_id: int):
        if (mac_address and self.interface1.mac_address == mac_address) or (self.interface1.port_id == port_id):
            return self.interface2
        return self.interface1


class RelationsContainer:
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
        unique = True
        for existing_relation in self.relations:
            if relation == existing_relation:
                unique = False
                break

        if unique:
            self.relations.append(relation)

    def find(self, mac_address: str, port_id: int):
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

    def find_by_port_id(self, port_id: int) -> Relation:
        found_relation = None
        for relation in self.relations:
            if port_id in [relation.interface1.port_id, relation.interface2.port_id]:
                found_relation = relation
                break
        return found_relation

    def find_by_mac(self, mac_address: str) -> Relation:
        found_relation = None
        for relation in self.relations:
            if mac_address in [relation.interface1.mac_address, relation.interface2.mac_address]:
                found_relation = relation
                break
        return found_relation


class Device:
    def __init__(self, device_id, name, os, model, device_type, interfaces):
        self.device_id = device_id
        self.name = name
        self.os = os
        self.model = model
        self.device_type = device_type

        self.interfaces = interfaces
