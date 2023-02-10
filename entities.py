class Interface:
    def __init__(self, interface_name: str, device_id: int, port_id: int, ip_address: str, mac_address: str, trunk: bool):
        self.interface_name = interface_name
        self.device_id = device_id
        self.port_id = port_id
        self.ip_address = ip_address
        self.mac_address = mac_address
        self.trunk = trunk

    def __str__(self):
        return f"{self.device_id}"


class Relation:
    def __init__(self, interface1: Interface, interface2: Interface):
        self.interface1 = interface1
        self.interface2 = interface2

    def __str__(self):
        return f"{self.interface1} -- {self.interface2}"

    def __eq__(self, other):
        return sorted((self.interface1.device_id, self.interface2.device_id)) == sorted((other.interface1.device_id, other.interface2.device_id))


class RelationsContainer:
    def __init__(self):
        self.relations = []

    def __str__(self):
        result = ""
        for relation in self.relations:
            result += f"{str(relation)}\n"

        return result

    def __iter__(self):
        self.index = 0
        return self

    def __next__(self):
        if self.index == len(self.relations):
            return StopIteration
        self.index += 1
        return self.relations[self.index - 1]

    def add(self, relation: Relation):
        unique = True
        for existing_relation in self.relations:
            if relation == existing_relation:
                unique = False
                break

        if unique:
            self.relations.append(relation)


class Device:
    def __init__(self, device_id, name, os):
        self.device_id = device_id
        self.name = name
        self.os = os

    def __str__(self):
        return f"{self.device_id} [label=\"{self.name}\", shape={'box' if self.os=='ios' else 'oval'}]\n"
