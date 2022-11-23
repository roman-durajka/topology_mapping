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

    def __iterate_mac_table_for_neighbourhood(self, source_interface: Interface, destination_interface: dict) -> bool:
        """Iterates through MAC table of a switch to check if given MAC address is a direct neighbour of this switch.
        :param source_interface: Interface object of source interface
        :param destination_interface: record of destination interface from table 'ports'
        :return: bool if devices are neighbors
        """
        if not self.db_client.get_data("ports_fdb", [("device_id", destination_interface["device_id"]), ("mac_address", source_interface.mac_address)]):
            return False

        #if "virtual" in str(destination_interface["ifType"]).lower() or "vlan" in str(destination_interface["ifAlias"]).lower():  # skip virtual interfaces
            #return False

        intermediary_devices = []

        for device_id in self.__extract_device_ids("ports_fdb"):
            records_to_source = self.db_client.get_data("ports_fdb", [("mac_address", source_interface.mac_address),
                                                                      ("device_id", device_id)])
            records_to_destination = self.db_client.get_data("ports_fdb",
                                                             [("mac_address", destination_interface["ifPhysAddress"]),
                                                              ("device_id", device_id)])

            if records_to_source and records_to_destination:
                for record_to_source in records_to_source:
                    for record_to_destination in records_to_destination:
                        if record_to_source["port_id"] != record_to_destination["port_id"]:
                            intermediary_devices.append((record_to_source, record_to_destination))

        if destination_interface["ifPhysAddress"] in ["002334ed9684"] and source_interface.device_id == 7:
            print("success")

        if not intermediary_devices:
            return True
        else:
            for intermediary_data in intermediary_devices:
                #  source device mac table
                source_to_destination_record = self.db_client.get_data("ports_fdb",
                                                                       [("device_id", source_interface.device_id), (
                                                                           "mac_address",
                                                                           destination_interface[
                                                                               "ifPhysAddress"])])[0]
                source_to_destination_port_id = source_to_destination_record["port_id"]
                source_intermediary_fdb_record = intermediary_data[0]
                source_intermediary_ports_record = self.db_client.get_data("ports",
                                                                           [("device_id",
                                                                             source_intermediary_fdb_record[
                                                                                 "device_id"]), (
                                                                                "port_id",
                                                                                source_intermediary_fdb_record[
                                                                                    "port_id"])])[0]
                source_to_intermediary_record = self.db_client.get_data("ports_fdb",
                                                                        [("device_id",
                                                                          source_interface.device_id), (
                                                                             "mac_address",
                                                                             source_intermediary_ports_record[
                                                                                 "ifPhysAddress"])])
                if not source_to_intermediary_record:  # (path to) intermediary is behind (or through) destination device
                    continue
                source_to_intermediary_record = source_to_intermediary_record[0]
                source_to_intermediary_port_id = source_to_intermediary_record["port_id"]

                #  destination device mac table
                destination_to_source_record = self.db_client.get_data("ports_fdb",
                                                                       [("device_id",
                                                                         destination_interface["device_id"]), (
                                                                            "mac_address",
                                                                            source_interface.mac_address)])[0]
                destination_to_source_port_id = destination_to_source_record["port_id"]
                destination_intermediary_fdb_record = intermediary_data[1]
                destination_intermediary_ports_record = self.db_client.get_data("ports",
                                                                                [("device_id",
                                                                                  destination_intermediary_fdb_record[
                                                                                      "device_id"]),
                                                                                 (
                                                                                     "port_id",
                                                                                     destination_intermediary_fdb_record[
                                                                                         "port_id"])])[0]
                destination_to_intermediary_record = self.db_client.get_data("ports_fdb",
                                                                             [("device_id",
                                                                               destination_interface["device_id"]),
                                                                              (
                                                                                  "mac_address",
                                                                                  destination_intermediary_ports_record[
                                                                                      "ifPhysAddress"])])
                if not destination_to_intermediary_record:  # (path to) intermediary is behind (or through) source device
                    continue
                destination_to_intermediary_record = destination_to_intermediary_record[0]
                destination_to_intermediary_port_id = destination_to_intermediary_record["port_id"]

                if source_to_destination_port_id == source_to_intermediary_port_id and destination_to_source_port_id == destination_to_intermediary_port_id:
                    return False
                #if source_to_destination_port_id != source_to_intermediary_port_id or destination_to_source_port_id != destination_to_intermediary_port_id:
                    #return False

            return True

    def __is_router_directly_connected(self, source_interface: Interface, destination_interface: dict) -> bool:
        """Checks whether router is directly connected or not.
        :param source_interface: Interface object of source interface
        :param destination_interface: record of destination interface from table 'ports'
        :return: bool if devices are neighbors
        """
        router_fdb_records = self.db_client.get_data("ports_fdb", [(
            "mac_address", destination_interface["ifPhysAddress"])])

        index_to_pop = -1
        for index, record in enumerate(router_fdb_records):
            if record["device_id"] == source_interface.device_id:
                index_to_pop = index
                break
        source_to_router_fdb_record = router_fdb_records.pop(index_to_pop)
        source_to_router_port_id = source_to_router_fdb_record["port_id"]

        for record in router_fdb_records:
            intermediate_device_id = record["device_id"]
            ports_mac_addresses = self.db_client.get_data("ports", [("device_id", intermediate_device_id)],
                                                          "ifPhysAddress")
            for mac_address in ports_mac_addresses:
                fdb_records = self.db_client.get_data("ports_fdb", [("device_id", source_interface.device_id), (
                    "mac_address", mac_address["ifPhysAddress"])])
                for fdb_record in fdb_records:
                    if fdb_record["port_id"] == source_to_router_port_id:
                        return False

        return True

    def __get_destination_interface(self, record: dict, source_interface: Interface) -> Interface:
        port_mac_address = record["mac_address"]
        port_records = self.db_client.get_data("ports", [("ifPhysAddress", port_mac_address)])
        if not port_records:
            raise ArithmeticError  # ????? nema zaznam
        port_record = port_records[0]

        if source_interface.device_id == 7 and port_record["device_id"] == 3:
            print("A")
            print(port_record["ifPhysAddress"])
        if source_interface.device_id == 3 and port_record["device_id"] == 7:
            print("B")

        #  interface_trunk = True if port_record["ifTrunk"] else False
        is_switch = str(port_record["device_id"]) in str(self.db_client.get_data("ports_fdb", None, "device_id"))
        is_router = str(port_record["port_id"]) in str(self.db_client.get_data("ipv4_addresses", None, "port_id"))

        records_on_port_count = len(self.db_client.get_data("ports_fdb", [("port_id", source_interface.port_id)]))
        if source_interface.trunk or records_on_port_count > 1:
            #  if interface_trunk:
            if is_switch:
                if not self.__iterate_mac_table_for_neighbourhood(source_interface, port_record):
                    raise ArithmeticError("Not neighbors")  # not neighbors
            else:
                if not self.__is_router_directly_connected(source_interface, port_record):
                    raise ArithmeticError("Not neighbors")  # not directly connected

        else:  # directly connected PC
            pass

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
