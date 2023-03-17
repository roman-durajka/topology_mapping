from modules.clients import MariaDBClient
from entities import RelationsContainer, Interface, Relation, Device
from modules.exceptions import UndefinedDeviceType
from ipaddress import IPv4Network, IPv4Address


class Extractor:
    def __init__(self, db_client: MariaDBClient):
        self.db_client = db_client

    def extract_device_ids(self, table: str):
        device_ids = []

        records = self.db_client.get_data(table, None, "device_id")
        for record in records:
            device_id = record["device_id"]
            if device_id not in device_ids:
                device_ids.append(device_id)
                yield device_id

    def extract_vlan_ids(self, table: str):
        vlan_ids = []

        records = self.db_client.get_data(table, None, "vlan_id")
        for record in records:
            vlan_id = record["vlan_id"]
            if vlan_id not in vlan_ids:
                vlan_ids.append(vlan_id)
                yield vlan_id

    def get_source_interface(self, device_id: int, port_id: int) -> Interface:
        if port_id == 0:
            raise ArithmeticError

        ports_table_data = self.db_client.get_data("ports", [("port_id", port_id), ("ifOperStatus", "up")])
        if not ports_table_data:
            raise ArithmeticError
        ports_table_data = ports_table_data[0]
        interface_trunk = False if not ports_table_data["ifTrunk"] else True
        interface_name = ports_table_data["ifName"]
        interface_mac_address = ports_table_data["ifPhysAddress"]
        interface_ip_address = self.db_client.get_data("ipv4_addresses", [("port_id", port_id)], "ipv4_address")
        if interface_ip_address:  # some interfaces don't have ip address
            interface_ip_address = interface_ip_address[0]["ipv4_address"]
        else:
            interface_ip_address = None

        return Interface(interface_name, device_id, port_id, interface_ip_address, interface_mac_address,
                         interface_trunk)

    def get_destination_interface(self, record: dict, source_interface: Interface) -> Interface:
        raise NotImplementedError

    def extract(self) -> RelationsContainer:
        raise NotImplementedError


class MacExtractor(Extractor):
    def __init__(self, db_client: MariaDBClient, relations: RelationsContainer):
        super().__init__(db_client)

        self.relations = relations

    def __is_directly_connected(self, source_interface: Interface, destination_interface: dict) -> bool:
        """Checks whether device is directly connected or not.
        :param source_interface: Interface object of source interface
        :param destination_interface: record of destination interface from table 'ports'
        :return: bool if devices are neighbors
        """
        device_fdb_records = self.db_client.get_data("ports_fdb", [(
            "mac_address", destination_interface["ifPhysAddress"])])

        index_to_pop = -1
        for index, record in enumerate(device_fdb_records):
            if record["device_id"] == source_interface.device_id:
                index_to_pop = index
                break
        source_to_device_fdb_record = device_fdb_records.pop(index_to_pop)
        source_to_device_port_id = source_to_device_fdb_record["port_id"]

        for record in device_fdb_records:
            intermediate_device_id = record["device_id"]
            intermediary_port_records = self.db_client.get_data("ports", [("device_id", intermediate_device_id), ("ifOperStatus", "up")])
            for intermediary_port_record in intermediary_port_records:
                if intermediary_port_record["port_id"] == record["port_id"]:
                    continue

                fdb_records = self.db_client.get_data("ports_fdb", [("port_id", source_to_device_port_id), (
                    "mac_address", intermediary_port_record["ifPhysAddress"])])
                if fdb_records:
                    return False
        return True

    def get_destination_interface(self, record: dict, source_interface: Interface) -> Interface:
        port_mac_address = record["mac_address"]
        port_records = self.db_client.get_data("ports", [("ifPhysAddress", port_mac_address), ("ifOperStatus", "up")])
        if not port_records:
            raise ArithmeticError  # ????? nema zaznam

        valid_port_record = None
        for port_record in port_records:
            if self.__is_directly_connected(source_interface, port_record):
                valid_port_record = port_record
                break

        if not valid_port_record:
            raise ArithmeticError("Not neighbors")  # not directly connected
        port_record = valid_port_record

        port_id = port_record["port_id"]
        interface_name = port_record["ifName"]
        device_id = port_record["device_id"]
        trunk = port_record["ifTrunk"]
        virtual = "virtual" in port_record["ifType"].lower()
        if virtual:
            # path algorithm
            pass
            #raise ArithmeticError
        mac_address = port_record["ifPhysAddress"]
        port_ip_address = self.db_client.get_data("ipv4_addresses", [("port_id", port_id)])

        if port_ip_address:  # some interfaces don't have ip address
            port_ip_address = port_ip_address[0]["ipv4_address"]
        else:
            port_ip_address = None

        return Interface(interface_name, device_id, port_id, port_ip_address, mac_address, trunk)

    def extract(self) -> RelationsContainer:
        for device_id in self.extract_device_ids("ports_fdb"):
            records = self.db_client.get_data("ports_fdb", [("device_id", device_id)])

            duplicates = []
            for record in records:
                if (record["port_id"], record["mac_address"]) in duplicates:
                    continue
                duplicates.append((record["port_id"], record["mac_address"]))
                try:
                    source_interface = self.get_source_interface(record["device_id"], record["port_id"])
                    destination_interface = self.get_destination_interface(record, source_interface)
                except ArithmeticError:
                    continue

                self.relations.add(Relation(source_interface, destination_interface))



        return self.relations


class IPExtractor(Extractor):
    def __init__(self, db_client: MariaDBClient, relations: RelationsContainer):
        super().__init__(db_client)

        self.relations = relations

    def get_destination_interface(self, record: dict, source_interface: Interface) -> Interface:
        destination_interface_network = record["inetCidrRouteDest"]
        destination_interface_network_prefix = record["inetCidrRoutePfxLen"]
        destination_network_obj = IPv4Network(f"{destination_interface_network}/{destination_interface_network_prefix}")
        source_interface_obj = IPv4Address(source_interface.ip_address)
        if source_interface_obj not in destination_network_obj:
            raise ArithmeticError("Different networks")

        source_interface_nexthop = record["inetCidrRouteNextHop"]
        if source_interface_nexthop == source_interface.ip_address:
            raise ArithmeticError

        network_devices = []
        ipv4_addresses_records = self.db_client.get_data("ipv4_addresses", [])
        for record in ipv4_addresses_records:
            ip_address = record["ipv4_address"]
            ip_address_obj = IPv4Address(ip_address)
            if ip_address_obj in destination_network_obj:
                network_devices.append(ip_address)

        if len(network_devices) != 2:  # intermediary devices exist, not neighbours
            raise ArithmeticError("More or less than two devices on network - no direct connection between source and destination")

        network_devices.remove(source_interface.ip_address)
        destination_interface_ip = network_devices[0]

        destination_interface_record = self.db_client.get_data("ipv4_addresses", [("ipv4_address", destination_interface_ip)])
        if not destination_interface_record:
            raise ArithmeticError("Has no interface?")

        destination_interface_port_id = destination_interface_record[0]["port_id"]
        port_record = self.db_client.get_data("ports", [("port_id", destination_interface_port_id)])[0]
        if "virtual" in port_record["ifType"].lower():
            # path algorithm
            pass
            #raise ArithmeticError("Virtual interface as destination")
        port_id = port_record["port_id"]
        interface_name = port_record["ifName"]
        device_id = port_record["device_id"]
        trunk = port_record["ifTrunk"]
        mac_address = port_record["ifPhysAddress"]
        port_ip_address = destination_interface_ip

        return Interface(interface_name, device_id, port_id, port_ip_address, mac_address, trunk)

    def extract(self) -> RelationsContainer:
        records = self.db_client.get_data("route", [("inetCidrRouteDestType", "ipv4")])
        for record in records:
            try:
                source_interface = self.get_source_interface(record["device_id"], record["port_id"])
                if not source_interface.ip_address: #or source_interface.ip_address in ["0.0.0.0", "127.0.0.1"]:
                    continue
                destination_interface = self.get_destination_interface(record, source_interface)
            except ArithmeticError:
                continue

            self.relations.add(Relation(source_interface, destination_interface))

        return self.relations


class DPExtractor(Extractor):
    def __init__(self, db_client: MariaDBClient, relations: RelationsContainer):
        super().__init__(db_client)

        self.relations = relations

    def get_destination_interface(self, record: dict, source_interface: Interface) -> Interface:
        return self.get_source_interface(record["remote_device_id"], record["remote_port_id"])

    def extract(self) -> RelationsContainer:
        records = self.db_client.get_data("links")
        for record in records:
            try:
                source_interface = self.get_source_interface(record["local_device_id"], record["local_port_id"])
                destination_interface = self.get_destination_interface(record, source_interface)
            except ArithmeticError:
                continue

            self.relations.add(Relation(source_interface, destination_interface))

        return self.relations


HOST_OPERATING_SYSTEMS = ["linux", "windows"]


class DeviceExtractor:
    def __init__(self, db_client: MariaDBClient):
        self.db_client = db_client

    def __get_device_type(self, device_id: int, os: str) -> str:
        if os in HOST_OPERATING_SYSTEMS:
            return "host"

        mac_records = self.db_client.get_data("ports_fdb", [("device_id", device_id)])
        has_switching_capabilities = True if mac_records else False
        route_records = self.db_client.get_data("route", [("device_id", device_id)])
        has_routing_capabilities = True if route_records else False

        if has_routing_capabilities and has_switching_capabilities:
            return "l3sw"

        if has_routing_capabilities:
            return "router"

        if has_switching_capabilities:
            return "switch"

        raise UndefinedDeviceType("Could not define device type!")

    def __get_interfaces(self, device_id: int):
        interfaces = {}
        ports = self.db_client.get_data("ports", [("device_id", device_id), ("ifOperStatus", "up")])
        for port_record in ports:
            interface_data = {"status": port_record["ifOperStatus"], "name": port_record["ifName"], "mac_address": "none", "ip_address": "none"}
            mac_address = port_record["ifPhysAddress"]
            if mac_address:
                interface_data["mac_address"] = mac_address
            ip_address_record = self.db_client.get_data("ipv4_addresses", [("port_id", port_record["port_id"])])
            if ip_address_record:
                ip_address = ip_address_record[0]["ipv4_address"]
                interface_data["ip_address"] = ip_address

            port_id = port_record["port_id"]
            interfaces[port_id] = interface_data

        return interfaces

    def extract(self) -> list:
        devices = []
        records = self.db_client.get_data("devices")
        for record in records:
            device_type = self.__get_device_type(record["device_id"], record["os"])
            interfaces = self.__get_interfaces(record["device_id"])

            device = Device(record["device_id"], record["sysName"], record["os"], record["hardware"], device_type, interfaces)
            devices.append(device)

        return devices
