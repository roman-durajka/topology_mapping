from modules.clients import MariaDBClient
from entities import RelationsContainer, Interface, Relation, Device


class MacExtractor:
    def __init__(self, db_client: MariaDBClient):
        self.db_client = db_client

        self.relations = RelationsContainer()

    def __extract_device_ids(self, table):
        device_ids = []

        records = self.db_client.get_data(table, None, "device_id")
        for record in records:
            device_id = record["device_id"]
            if device_id not in device_ids:
                device_ids.append(device_id)
                yield device_id

    def __get_source_interface(self, record: dict) -> Interface:
        device_id = record["device_id"]
        port_id = record["port_id"]
        if port_id == 0:
            #  TODO: opytat sa - port id 0 nepatri nikomu?
            raise ArithmeticError

        ports_table_data = self.db_client.get_data("ports", [("port_id", port_id)])[0]
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
            intermediary_port_records = self.db_client.get_data("ports", [("device_id", intermediate_device_id)])
            for intermediary_port_record in intermediary_port_records:
                if intermediary_port_record["ifType"] == "propVirtual":
                    continue
                if intermediary_port_record["port_id"] == record["port_id"]:
                    continue
                fdb_records = self.db_client.get_data("ports_fdb", [("device_id", source_interface.device_id), (
                    "mac_address", intermediary_port_record["ifPhysAddress"])])
                for fdb_record in fdb_records:
                    if fdb_record["port_id"] == source_to_device_port_id:
                        return False

        return True

    def __get_destination_interface(self, record: dict, source_interface: Interface) -> Interface:
        port_mac_address = record["mac_address"]
        port_records = self.db_client.get_data("ports", [("ifPhysAddress", port_mac_address)])
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
        mac_address = port_record["ifPhysAddress"]
        port_ip_address = self.db_client.get_data("ipv4_addresses", [("port_id", port_id)])

        if port_ip_address:  # some interfaces don't have ip address
            port_ip_address = port_ip_address[0]["ipv4_address"]
        else:
            port_ip_address = None

        return Interface(interface_name, device_id, port_id, port_ip_address, mac_address, trunk)

    def extract(self) -> str:
        for device_id in self.__extract_device_ids("ports_fdb"):
            records = self.db_client.get_data("ports_fdb", [("device_id", device_id)])

            mac_addresses = []
            for record in records:
                if record["mac_address"] in mac_addresses:
                    continue
                mac_addresses.append(record["mac_address"])
                try:
                    source_interface = self.__get_source_interface(record)
                    destination_interface = self.__get_destination_interface(record, source_interface)
                except ArithmeticError:
                    continue

                self.relations.add(Relation(source_interface, destination_interface))

        return str(self.relations)


class DeviceExtractor:
    def __init__(self, db_client: MariaDBClient):
        self.db_client = db_client

    def extract(self) -> str:
        devices = []
        records = self.db_client.get_data("devices", None, "device_id", "sysName")
        for record in records:
            device = Device(record["device_id"], record["sysName"])
            devices.append(device)

        result = ""
        for device in devices:
            result += f"{str(device)}"

        return result
