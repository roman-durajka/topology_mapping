from modules.clients import MariaDBClient
from modules.exceptions import DuplicitDBEntry, CommonDBError, MissingFKError, NotFoundError, NotImplementedError, InvalidInsertedData
import path
import topology

import ipaddress


def insert_into_table_route(db_client: MariaDBClient, data_to_insert: dict):
    """Inserts data into table `route` using Librenms DB connection.
    This function is supposed to fill in any unneccessary columns into the
    inserting dict, because many of them are marked as NOT NULL.
    Only necessary columns that have to be in the data_to_insert param are:
    device_id, port_id, inetCidrRouteDest, inetCidrRouteNextHop,
    inetCidrRoutePfxLen.

    TODO: use this function on places where manual column insertion
    is already present"""
    data_to_insert.update({
        "inetCidrRouteIfIndex": 0,
        "inetCidrRouteType": 0,
        "inetCidrRouteProto": 0,
        "inetCidrRouteNextHopAS": 0,
        "inetCidrRouteMetric1": 0,
        "inetCidrRouteDestType": "ipv4",
        "inetCidrRouteNextHopType": "ipv4",
        "inetCidrRoutePolicy": ""
    })
    db_client.insert_data([data_to_insert], "route")


class SchemeImportLibreNMS:
    SCHEME_ATTRS_IN_ORDER = [
        "devices", "vlans", "ports", "ipv4_networks", "ipv4_addresses",
        "ipv4_mac", "links", "ports_fdb", "route"
    ]
    COLUMN_DATA_TYPE_MAP = {
        str: ["varchar", "text", "varbinary"],
        int: ["int", "tinyint", "double", "bigint"]
    }
    # {scheme_table_name: {scheme_record_name: (FK_table_name, FK_column_name)}}
    FK_CHECK_MAP = {
        "ports": {
            "device_id": ("devices", "device_id"),
            "ifVlan": ("vlans", "vlan_vlan")
        },
        "vlans": {
            "device_id": ("devices", "device_id")
        },
        "ipv4_addresses": {
            "ipv4_network_id": ("ipv4_networks", "ipv4_network_id"),
            "port_id": ("ports", "port_id")
        },
        "ipv4_mac": {
            "port_id": ("ports", "port_id"),
            "device_id": ("devices", "device_id"),
            "ipv4_address": ("ipv4_addresses", "ipv4_address"),
            "mac_address": ("ports", "ifPhysAddress")
        },
        "links": {
            "local_port_id": ("ports", "port_id"),
            "remote_port_id": ("ports", "port_id"),
            "local_device_id": ("devices", "device_id"),
            "remote_device_id": ("devices", "device_id")
        },
        "ports_fdb": {
            "device_id": ("devices", "device_id"),
            "port_id": ("ports", "port_id"),
            "mac_address": ("ports", "ifPhysAddress")
        },
        "route": {
            "device_id": ("devices", "device_id"),
            "port_id": ("ports", "port_id"),
            "inetCidrRouteNextHop": ("ipv4_addresses", "ipv4_address")
        }
    }

    def __init__(self, scheme_json: dict):
        self.db_client = MariaDBClient("librenms")
        self.scheme_json = scheme_json

    def __map_optional_attribute(self, table_name: str, id_key: str,
                                 attribute_key: str,
                                 attribute_value: str | int,
                                 optional_values: dict):
        # if not in db, check user defined scheme, and if not there, add new record to scheme
        attr_id = None
        attr_record = self.db_client.get_data(
            table_name, [(attribute_key, attribute_value)])
        if not attr_record:
            if table_name in self.scheme_json.keys():
                for scheme_record in self.scheme_json[table_name]:
                    if scheme_record[attribute_key] == attribute_value:
                        attr_id = scheme_record[id_key]
                        break
        else:
            attr_id = attr_record[0][id_key]

        if not attr_id:
            if table_name in self.scheme_json.keys():
                max_id = 0
                for scheme_record in self.scheme_json[table_name]:
                    if scheme_record[id_key] > max_id:
                        max_id = scheme_record[id_key]
                attr_id = max_id + 1
            else:
                attr_records = self.db_client.get_data(table_name)
                max_id = 0
                for attr_record in attr_records:
                    if attr_record[id_key] > max_id:
                        max_id = attr_record[id_key]
                attr_id = max_id + 1

            # add new attr record to scheme
            attr_json = {id_key: attr_id}
            attr_json.update(optional_values)
            if table_name not in self.scheme_json:
                self.scheme_json[table_name] = []
            self.scheme_json[table_name].append(attr_json)

        return attr_id

    def __pad_forced_attributes(self, data_to_insert: list[dict],
                                table_name: str):
        """Adds some necessarry attributes required by librenms, but not really
        needed to be put in by user. Without them it would not be possible to
        insert data into DB, but also it would not be wise to ask user to
        fill in fe. status_reason etc..."
        TODO: make more generic
        """
        if table_name == "devices":
            for record in data_to_insert:
                record.update({"status_reason": ""})
        if table_name == "ipv4_mac":
            for record in data_to_insert:
                record.update({"context_name": ""})
        if table_name == "links":
            for record in data_to_insert:
                record.update({
                    "remote_version": "",
                    "remote_port": "",
                    "remote_hostname": ""
                })
        if table_name == "route":
            for record in data_to_insert:
                record.update({
                    "inetCidrRouteIfIndex": 0,
                    "inetCidrRouteType": 0,
                    "inetCidrRouteProto": 0,
                    "inetCidrRouteNextHopAS": 0,
                    "inetCidrRouteMetric1": 0,
                    "inetCidrRouteDestType": "ipv4",
                    "inetCidrRouteNextHopType": "ipv4",
                    "inetCidrRoutePolicy": ""
                })

        # map IPs and vlan_ids
        if table_name == "ipv4_addresses":
            for index, record in enumerate(data_to_insert):
                if "ipv4_address" not in record.keys():
                    raise CommonDBError(
                        f"column {'ipv4_address'} missing in record {index} for table {table_name}"
                    )

                ip = record["ipv4_address"]
                prefix = int(record["ipv4_prefixlen"])

                network_obj = ipaddress.IPv4Network(f"{ip}/{prefix}", strict=False)
                network_address = f"{network_obj.network_address}/{prefix}"

                network_id = self.__map_optional_attribute(
                    "ipv4_networks", "ipv4_network_id", "ipv4_network",
                    network_address, {"ipv4_network": network_address})
                data_to_insert[index]["ipv4_network_id"] = str(network_id)

        if table_name == "ports_fdb":
            for index, record in enumerate(data_to_insert):
                if "vlan_vlan" not in record.keys():
                    raise CommonDBError(
                        f"column {'vlan_vlan'} missing in record {index} for table {table_name}"
                    )

                vlan = record["vlan_vlan"]
                vlan_id = self.__map_optional_attribute(
                    "vlans", "vlan_id", "vlan_vlan", vlan,
                    {"vlan_vlan": vlan})
                data_to_insert[index]["vlan_id"] = vlan_id
                del data_to_insert[index]["vlan_vlan"]

    def __fk_custom_checks(self, table_name: str, data_to_insert: dict):
        """Complements the `check_fk_existence` method with custom checks that
        could not be used within it universally."""

        # custom check for table route, record dest network
        if table_name == "route":
            for index, record in enumerate(data_to_insert):
                route_dest = f"{record['inetCidrRouteDest']}/{record['inetCidrRoutePfxLen']}"
                record_name = "inetCidrRouteDest"
                fk_table_name = "ipv4_networks"
                fk_column_name = "ipv4_network"

                self.__check_fk_in_scheme(route_dest, fk_table_name,
                                          fk_column_name, "route", index,
                                          record_name)

                # no need to check id compatibility, it was already checked
                # universally for table `route`

    def __check_fk_in_scheme(self, attr_value: str | int, fk_table_name: str,
                             fk_column_name: str, table_name: str, index: int,
                             attr_name: str):
        if not self.db_client.get_data(fk_table_name,
                                       [(fk_column_name, attr_value)]):
            # also check user defined scheme
            found = False
            if fk_table_name in self.scheme_json.keys():
                for scheme_record in self.scheme_json[fk_table_name]:
                    record_val = scheme_record[fk_column_name]
                    if type(record_val) is not type(attr_value):
                        if str(record_val) == str(attr_value):
                            found = True
                            break
                    elif scheme_record[fk_column_name] == attr_value:
                        found = True
                        break
            if not found:
                raise MissingFKError(table_name, index, attr_name)

    def __check_id_compatibility(self, record: dict, table_name: str,
                                 index: int):
        """Checks whether device_id and port_id match the same device.
        It would cause issues if device_id was specified for fe. R1 and
        port_id was representing port on another device, fe. R2."""
        if all(key in record.keys() for key in ["device_id", "port_id"]):
            if not self.db_client.get_data(
                    "ports", [("port_id", record["port_id"]),
                              ("device_id", record["device_id"])]):
                # check user defined scheme
                found = False
                if "ports" in self.scheme_json.keys():
                    for scheme_record in self.scheme_json["ports"]:
                        if scheme_record["port_id"] == record["port_id"]:
                            if scheme_record["device_id"] == record[
                                    "device_id"]:
                                found = True
                                break
                if not found:
                    raise CommonDBError(
                        f"Device_id and port_id don't refer to the same device for table: {table_name}, record: {index}"
                    )

    def __check_fk_existence(self, data_to_insert: list[dict],
                             table_name: str):
        """Checks if FK values (fe. port_id or device_id) exist in others
        tables (as PK)."""

        for index, record in enumerate(data_to_insert):
            for record_name, fk_attributes in self.FK_CHECK_MAP[
                    table_name].items():
                record_value = record[record_name]
                fk_table_name = fk_attributes[0]
                fk_column_name = fk_attributes[1]
                self.__check_fk_in_scheme(record_value, fk_table_name,
                                          fk_column_name, table_name, index,
                                          record_name)

            # if device_id and port_id are both present in record, check if they match
            self.__check_id_compatibility(record, table_name, index)

        self.__fk_custom_checks(table_name, data_to_insert)

    def __check_scheme_validity(self, data_to_insert: list[dict],
                                table_name: str):
        # check for NOT NULL attributes
        not_null_columns = self.db_client.get_columns(table_name, True, True)
        for column_name in not_null_columns:
            for index, record in enumerate(data_to_insert):
                if column_name not in record.keys():
                    raise CommonDBError(
                        f"NOT NULL column {column_name} missing in record {index} for table {table_name}"
                    )

        # check for not allowed column names and data types
        all_columns = self.db_client.get_columns(table_name)
        column_data_types = self.db_client.get_column_data_types(table_name)

        for index, record in enumerate(data_to_insert):
            for key in record.keys():
                if key not in all_columns:
                    raise CommonDBError(
                        f"Column name {key} not allowed here in record {index} for table {table_name}"
                    )
                if column_data_types[key] not in self.COLUMN_DATA_TYPE_MAP[
                        type(record[key])]:
                    raise CommonDBError(
                        f"Wrong data type of column {key} in record {index} for table {table_name}"
                    )

        # check for duplicities
        pk_columns = self.db_client.get_columns(table_name, False, False, True)

        query_list = []
        for pk in pk_columns:
            if pk in record.keys():
                query_list.append((pk, record[pk]))

        if query_list:
            query_result = self.db_client.get_data(table_name, query_list)
            if query_result:
                raise DuplicitDBEntry(
                    "You are trying to insert data that is already in the database"
                )

    def __make_neighbors_up(self, data_to_insert: list[dict]):
        for record in data_to_insert:
            for port_id in [record["local_port_id"], record["remote_port_id"]]:
                self.db_client.update_data("ports", [{"ifOperStatus": "up"}],
                                           [("port_id", port_id)])

    def update_db_from_scheme(self, skip_checks: bool = False):
        for attr in self.SCHEME_ATTRS_IN_ORDER:
            if attr not in self.scheme_json.keys():
                continue
            data_to_insert = self.scheme_json[attr]

            if data_to_insert:
                # add NOT NULL attributes not important for the user but needed by librenms
                self.__pad_forced_attributes(data_to_insert, attr)

                # skip when uploading data second time
                if skip_checks:
                    continue

                # check validity
                self.__check_scheme_validity(data_to_insert, attr)

                # check fks
                if attr in self.FK_CHECK_MAP:
                    self.__check_fk_existence(data_to_insert, attr)


        # insert data
        for attr in self.SCHEME_ATTRS_IN_ORDER:
            if attr not in self.scheme_json.keys():
                continue
            data_to_insert = self.scheme_json[attr]

            # if inserting cdp/lldp, make ifs go UP in status
            if attr == "links":
                self.__make_neighbors_up(data_to_insert)

            if data_to_insert:
                try:
                    self.db_client.insert_data(data_to_insert, attr, False)
                    self.db_client.commit()
                except Exception as e:
                    self.db_client.rollback()
                    raise e

        topology_obj = topology.Topology()
        # force DP algorithm with new data
        topology_obj.create_topology()
        # force X, Y coords calculation
        topology_obj.update_uninitialized_coords()


class Devices:
    def __init__(self):
        self.topology_db_client = MariaDBClient("topology")
        self.librenms_db_client = MariaDBClient("librenms")

    def __get_device_data(self, device_id: int):
        """
        Returns dict that contains basic data about device.

        :param device_id: id of device
        :return: dict containing basic device data
        """
        device_record = self.librenms_db_client.get_data("devices", [("device_id", device_id)])
        if not device_record:
            raise NotFoundError("Could not find device from topology inside librenms DB. How could this happen?")
        device_record = device_record[0]

        device_details = {
            1: {
                "hardware_title": {
                    "name": "Device detail",
                    "value": "Model",
                    "editable": False
                },
                "hardware_value": {
                    "name": "Value",
                    "value": device_record["hardware"],
                    "editable": True
                }
            },
            2: {
                "os_title": {
                    "name": "Device detail",
                    "value": "Operating system",
                    "editable": False
                },
                "os_value": {
                    "name": "Value",
                    "value": device_record["os"],
                    "editable": True
                }
            },
            4: {
                "version_title": {
                    "name": "Device detail",
                    "value": "OS version",
                    "editable": False
                },
                "version_value": {
                    "name": "Value",
                    "value": device_record["version"],
                    "editable": True
                }
            },
            5: {
                "description_title": {
                    "name": "Device detail",
                    "value": "Description",
                    "editable": False
                },
                "description_value": {
                    "name": "Value",
                    "value": device_record["sysDescr"],
                    "editable": True
                }
            }
        }

        device_data = {
            "name": device_record["sysName"],
            "details": device_details
        }

        return device_data

    def __get_device_interfaces(self, device_id: int):
        """
        Returns dict that contains device interfaces.

        :param device_id: id of device
        :return: dict containing device if data
        """
        interfaces = {}

        interface_records = self.librenms_db_client.get_data("ports", [("device_id", device_id)])
        for interface_record in interface_records:
            interface_id = interface_record["port_id"]
            ip_address_record = self.librenms_db_client.get_data("ipv4_addresses", [("port_id", interface_id)])
            ip_address = "" if not ip_address_record else f"{ip_address_record[0]['ipv4_address']}/{ip_address_record[0]['ipv4_prefixlen']}"

            interface_data = {
                "if_id": {
                    "value": interface_id,
                    "name": "Interface ID",
                    "editable": False
                },
                "status": {
                    "value": interface_record["ifOperStatus"],
                    "name": "Status",
                    "editable": True
                },
                "mac_address": {
                    "value": interface_record["ifPhysAddress"],
                    "name": "MAC Address",
                    "editable": True
                },
                "if_name": {
                    "value": interface_record["ifName"],
                    "name": "Interface name",
                    "editable": True
                },
                "ip_address": {
                    "value": ip_address,
                    "name": "IP Address",
                    "editable": True
                }
            }

            interfaces.update({interface_id: interface_data})
        if not interfaces:
            interfaces = {-1: {
                "if_id": {
                    "value": "",
                    "name": "Interface ID",
                    "editable": False
                },
                "status": {
                    "value": "",
                    "name": "Status",
                    "editable": True
                },
                "mac_address": {
                    "value": "",
                    "name": "MAC Address",
                    "editable": True
                },
                "if_name": {
                    "value": "",
                    "name": "Interface name",
                    "editable": True
                },
                "ip_address": {
                    "value": "",
                    "name": "IP Address",
                    "editable": True
                }
            }}

        return interfaces

    def __get_device_routing_table(self, device_id: int):
        """
        Returns device routing table.

        :param device_id: id of device
        :return: dict containing device routing table
        """
        routing_table = {}

        routing_table_records = self.librenms_db_client.get_data("route", [("device_id", device_id)])
        for record in routing_table_records:
            route_id = record["route_id"]
            if_record = self.librenms_db_client.get_data("ports", [("port_id", record["port_id"])])[0]

            nexthop = record["inetCidrRouteNextHop"]
            nexthop_device_name = ""
            if nexthop not in ["0.0.0.0", "127.0.0.1"]:
                ip_address_record = self.librenms_db_client.get_data("ipv4_addresses", [("ipv4_address", nexthop)])
                if ip_address_record:
                    ip_address_record = ip_address_record[0]
                    nexthop_port_record = self.librenms_db_client.get_data("ports", [("port_id", ip_address_record["port_id"])])[0]
                    nexthop_device_record = self.librenms_db_client.get_data("devices", [("device_id", nexthop_port_record["device_id"])])[0]
                    nexthop_device_name = nexthop_device_record["sysName"]

            destionation = f"{record['inetCidrRouteDest']}/{record['inetCidrRoutePfxLen']}"

            route = {
                "if_id": {
                    "value": record["port_id"],
                    "name": "Interface ID",
                    "editable": False
                },
                "if_name": {
                    "value": if_record["ifName"],
                    "name": "Interface name",
                    "editable": True
                },
                "destination": {
                    "value": destionation,
                    "name": "Destination",
                    "editable": True
                },
                "nexthop": {
                    "value": record["inetCidrRouteNextHop"],
                    "name": "Nexthop",
                    "editable": True
                },
                "nexthop_name": {
                    "value": nexthop_device_name,
                    "name": "Nexthop name",
                    "editable": False
                }
            }

            routing_table.update({route_id: route})
        if not routing_table:
            routing_table = {-1: {
                "if_id": {
                    "value": "",
                    "name": "Interface ID",
                    "editable": False
                },
                "if_name": {
                    "value": "",
                    "name": "Interface name",
                    "editable": True
                },
                "destination": {
                    "value": "",
                    "name": "Destination",
                    "editable": True
                },
                "prefix_len": {
                    "value": "",
                    "name": "Destination prefix",
                    "editable": True
                },
                "nexthop": {
                    "value": "",
                    "name": "Nexthop",
                    "editable": True
                },
                "nexthop_name": {
                    "value": "",
                    "name": "Nexthop name",
                    "editable": False
                }
            }}

        return routing_table

    def __get_device_mac_table(self, device_id: int):
        """
        Returns device mac table.

        :param device_id: id of device
        :return: dict containing device mac table
        """
        mac_table = {}

        mac_table_records = self.librenms_db_client.get_data("ports_fdb", [("device_id", device_id)])
        for record in mac_table_records:
            route_id = record["ports_fdb_id"]
            vlan_id = record["vlan_id"]
            vlan = self.librenms_db_client.get_data("vlans", [("vlan_id", vlan_id)])[0]["vlan_vlan"]

            local_if_record = self.librenms_db_client.get_data("ports", [("port_id", record["port_id"])])[0]
            remote_if_record = self.librenms_db_client.get_data("ports", [("ifPhysAddress", record["mac_address"])])
            if not remote_if_record:  # there is no point in showing record that points to non-existing interface
                continue
            remote_if_record = remote_if_record[0]
            remote_device_record = self.librenms_db_client.get_data("devices", [("device_id", remote_if_record["device_id"])])[0]

            route = {
                # local
                "local_if_id": {
                    "value": record["port_id"],
                    "name": "Local IF ID",
                    "editable": False
                },
                "local_if_name": {
                    "value": local_if_record["ifName"],
                    "name": "Local IF name",
                    "editable": False
                },
                "local_if_mac": {
                    "value": local_if_record["ifPhysAddress"],
                    "name": "Local IF MAC",
                    "editable": True
                },
                # destination
                "destination_name": {
                    "value": remote_device_record["sysName"],
                    "name": "Destination device",
                    "editable": False
                },
                "destination_if_id": {
                    "value": remote_if_record["port_id"],
                    "name": "Destination IF ID",
                    "editable": False
                },
                "destination_if_name": {
                    "value": remote_if_record["ifName"],
                    "name": "Destination IF name",
                    "editable": False
                },
                "destination_if_mac": {
                    "value": record["mac_address"],
                    "name": "Destination IF MAC",
                    "editable": True
                },
                "vlan": {
                    "value": vlan,
                    "name": "VLAN",
                    "editable": True
                }
            }

            mac_table.update({route_id: route})
        if not mac_table:
            mac_table = {-1: {
                "local_if_id": {
                    "value": "",
                    "name": "Local IF ID",
                    "editable": False
                },
                "local_if_name": {
                    "value": "",
                    "name": "Local IF name",
                    "editable": False
                },
                "local_if_mac": {
                    "value": "",
                    "name": "Local IF MAC",
                    "editable": True
                },
                # destination
                "destination_name": {
                    "value": "",
                    "name": "Destination device",
                    "editable": False
                },
                "destination_if_id": {
                    "value": "",
                    "name": "Destination IF ID",
                    "editable": False
                },
                "destination_if_name": {
                    "value": "",
                    "name": "Destination IF name",
                    "editable": False
                },
                "destination_if_mac": {
                    "value": "",
                    "name": "Destination IF MAC",
                    "editable": True
                },
                "vlan": {
                    "value": "",
                    "name": "VLAN",
                    "editable": True
                }
            }}

        return mac_table

    def __get_device_arp_table(self, device_id: int):
        """
        Returns device arp table. Every ARP record has to be tied to an interface (not neccessarily device).

        :param device_id: id of device
        :return: dict containing device arp table
        """
        arp_table = {}

        arp_table_records = self.librenms_db_client.get_data("ipv4_mac", [("device_id", device_id)])
        for record in arp_table_records:
            arp_id = record["id"]
            if_record = self.librenms_db_client.get_data("ports", [("port_id", record["port_id"])])[0]
            if_name = if_record["ifName"]

            ip_record = self.librenms_db_client.get_data("ipv4_addresses", [("ipv4_address", record["ipv4_address"])])
            if not ip_record:
                continue
            ip_record = ip_record[0]
            ip_address = f"{ip_record['ipv4_address']}/{ip_record['ipv4_prefixlen']}"

            arp_record = {
                "if_id": {
                    "value": record["port_id"],
                    "name": "Interface ID",
                    "editable": False
                },
                "if_name": {
                    "value": if_name,
                    "name": "Interface name",
                    "editable": True
                },
                "mac_address": {
                    "value": record["mac_address"],
                    "name": "MAC Address",
                    "editable": True
                },
                "ip_address": {
                    "value": ip_address,
                    "name": "IP Address",
                    "editable": True
                }
            }

            arp_table.update({arp_id: arp_record})
        if not arp_table:
            arp_table = {-1: {
                "if_id": {
                    "value": "",
                    "name": "Interface ID",
                    "editable": False
                },
                "if_name": {
                    "value": "",
                    "name": "Interface name",
                    "editable": True
                },
                "mac_address": {
                    "value": "",
                    "name": "MAC Address",
                    "editable": True
                },
                "ip_address": {
                    "value": "",
                    "name": "IP Address",
                    "editable": True
                }
            }}

        return arp_table

    def __get_device_discovery_protocols(self, device_id: int) -> dict:
        """
        Returns device DP (cdp/lldp) table.

        :param device_id: id of device
        :return: dict containing device dp table
        """
        dp_table = {}

        dp_table_records = self.librenms_db_client.get_data("links", [("local_device_id", device_id)])
        for record in dp_table_records:
            record_id = record["id"]

            # local device data
            local_port_id = record["local_port_id"]
            local_port_record = self.librenms_db_client.get_data("ports", [("port_id", local_port_id)])[0]
            local_port_name = local_port_record["ifName"]
            local_port_mac = local_port_record["ifPhysAddress"]

            # remote device data
            remote_port_id = record["remote_port_id"]
            remote_port_record = self.librenms_db_client.get_data("ports", [("port_id", remote_port_id)])[0]
            remote_port_name = remote_port_record["ifName"]
            remote_port_mac = remote_port_record["ifPhysAddress"]
            remote_device_id = remote_port_record["device_id"]
            remote_device_record = self.librenms_db_client.get_data("devices", [("device_id", remote_device_id)])[0]
            remote_device_name = remote_device_record["sysName"]

            dp_record = {
                "local_if_id": {
                    "value": local_port_id,
                    "name": "Local IF ID",
                    "editable": True
                },
                "remote_if_id": {
                    "value": remote_port_id,
                    "name": "Remote IF ID",
                    "editable": True
                },
                "local_if_name": {
                    "value": local_port_name,
                    "name": "Local IF name",
                    "editable": False
                },
                "remote_if_name": {
                    "value": remote_port_name,
                    "name": "Remote IF name",
                    "editable": False
                },
                "local_mac_address": {
                    "value": local_port_mac,
                    "name": "Local IF MAC",
                    "editable": False
                },
                "remote_mac_address": {
                    "value": remote_port_mac,
                    "name": "Remote IF MAC",
                    "editable": False
                },
                "remote_device_name": {
                    "value": remote_device_name,
                    "name": "Remote device",
                    "editable": False
                }
            }

            dp_table.update({record_id: dp_record})
        if not dp_table:
            dp_table = {-1: {
                "local_if_id": {
                    "value": "",
                    "name": "Local IF ID",
                    "editable": False
                },
                "remote_if_id": {
                    "value": "",
                    "name": "Remote IF ID",
                    "editable": False
                },
                "local_if_name": {
                    "value": "",
                    "name": "Local IF name",
                    "editable": False
                },
                "remote_if_name": {
                    "value": "",
                    "name": "Remote IF name",
                    "editable": False
                },
                "local_mac_address": {
                    "value": "",
                    "name": "Local IF MAC",
                    "editable": True
                },
                "remote_mac_address": {
                    "value": "",
                    "name": "Remote IF MAC",
                    "editable": True
                },
                "remote_device_name": {
                    "value": "",
                    "name": "Remote device",
                    "editable": False
                }
            }}

        return dp_table

    def get_devices(self):
        """
        Returns all data about devices needed by subpage `devices`.Devices()

        :return: dict
        """
        devices = {}
        records = self.topology_db_client.get_data("nodes", None, "id")
        for record in records:
            device_id = record["id"]
            device_data = self.__get_device_data(device_id)

            interfaces = self.__get_device_interfaces(device_id)
            device_data.update({"interfaces": interfaces})

            routing_table = self.__get_device_routing_table(device_id)
            device_data.update({"routing_table": routing_table})

            mac_table = self.__get_device_mac_table(device_id)
            device_data.update({"mac_table": mac_table})

            arp_table = self.__get_device_arp_table(device_id)
            device_data.update({"arp_table": arp_table})

            dp_table = self.__get_device_discovery_protocols(device_id)
            device_data.update({"dp_table": dp_table})

            devices.update({device_id: device_data})

        return devices

    def __update_table_devices(self, data: dict):
        self.librenms_db_client.update_data("devices", [{"sysName": data["name"]}], [("device_id", data["id"])])
        return {}

    def __update_table_device_details(self, data: dict):
        device_id = data["deviceId"]
        match data["Device detail"]:
            case "Model":
                column_name = "hardware"
            case "Operating system":
                column_name = "os"
            case "OS version":
                column_name = "version"
            case "Description":
                column_name = "sysDescr"
            case _:
                raise InvalidInsertedData("Attribute name you entered is invalid.")

        self.librenms_db_client.update_data("devices", [{column_name: data["Value"]}], [("device_id", device_id)])
        return {}

    def __check_ip_addr_existence(self, ip_addr: str):
        """Checks whether IP address already exists. Returns true
        if it exists, and false if not."""
        ip_addr_record = self.librenms_db_client.get_data("ipv4_addresses", [("ipv4_address", ip_addr)])
        if ip_addr_record:
            return True
        return False

    def __check_network_existence(self, ip_addr_with_mask: str):
        """Checks whether IP network already exists. Returns true
        if it exists, and false if not. IP address of the network should
        be passed with mask, fe. 10.0.0.0/30."""
        network_record = self.librenms_db_client.get_data("ipv4_networks", [("ipv4_network", ip_addr_with_mask)])
        if network_record:
            return True
        return False


    def __check_ip_addr_validity(self, ip_addr_with_mask: str) -> None:
        error_str = "IP address you inserted is not in valid format. It should be in format IP/MASK PREFIX."
        if "/" not in ip_addr_with_mask:
            raise InvalidInsertedData(error_str)
        ip_addr_parts = ip_addr_with_mask.split("/")
        ip_addr = ip_addr_parts[0]
        mask = ip_addr_parts[1]
        if not ip_addr or not mask:
            raise InvalidInsertedData(error_str)

        if len(ip_addr_with_mask) > 19:
            raise InvalidInsertedData("IP address you entered is too long. IP and MASK PREFIX including dots should be max. 19 characters long.")

        try:
            ipaddress.IPv4Network(f"{ip_addr}/{mask}", strict=False)
        except (ipaddress.AddressValueError, ipaddress.NetmaskValueError):
            raise InvalidInsertedData("IP address you entered is invalid.")

    def __insert_ip_addr_record(self, ip_addr_with_mask: str, port_id: str) -> None:
        ip_addr_parts = ip_addr_with_mask.split("/")
        ip_addr = ip_addr_parts[0]
        mask = ip_addr_parts[1]

        # first check if network exists, if not, then create new
        network_obj = ipaddress.IPv4Network(f"{ip_addr}/{mask}", strict=False)
        network = f"{network_obj.network_address}/{mask}"
        network_record = self.librenms_db_client.get_data("ipv4_networks", [("ipv4_network", network)])
        if not network_record:  # create new
            self.librenms_db_client.insert_data([{"ipv4_network": network}], "ipv4_networks")
            network_id = self.librenms_db_client.get_data("ipv4_networks", [("ipv4_network", network)])[0]["ipv4_network_id"]
        else:  # use existing
            network_id = network_record[0]["ipv4_network_id"]

        data_to_insert = {
            "ipv4_network_id": network_id,
            "ipv4_address": ip_addr,
            "ipv4_prefixlen": mask,
            "port_id": port_id
        }
        self.librenms_db_client.insert_data([data_to_insert], "ipv4_addresses")

    def __check_mac_addr_validity(self, mac_address: str, requireExisting: bool):
        """
        Checks if MAC has the right length and also checks it's existence in DB.
        If requireExisting is True, raises error if MAC does not exist in DB,
        and if requireExisting is False, raises error if MAC is used by
        another device.

        TODO: split into validity and existence methods (like IP)
        """
        if len(mac_address) != 12:
            raise InvalidInsertedData("MAC address is not the right length.")
        mac_addr_record = self.librenms_db_client.get_data("ports", [("ifPhysAddress", mac_address)])
        if mac_addr_record and not requireExisting:
            raise DuplicitDBEntry("MAC address you entered is already used by another device.")
        if not mac_addr_record and requireExisting:
            raise InvalidInsertedData("MAC address you entered does not belong to any device.")

    def __update_table_interfaces(self, data: dict):
        data_to_update = {}
        data_to_return = {}

        for key, value in data.items():
            if key == "Status":
                data_to_update["ifOperStatus"] = value
            if key == "MAC Address":
                self.__check_mac_addr_validity(value, False)
                data_to_update["ifPhysAddress"] = value
                data_to_return["MAC Address"] = value
            if key == "Interface name":
                data_to_update["ifName"] = value
            if key == "IP Address":
                self.__check_ip_addr_validity(value)
                ip_addr = value.split("/")[0]
                ip_addr_record = self.librenms_db_client.get_data("ipv4_addresses", [("ipv4_address", ip_addr)])
                if ip_addr_record:
                    raise DuplicitDBEntry("IP address you entered is already used by another device.")
                data_to_return["IP Address"] = value

        port_id = ""
        if "id" in data.keys():
            if data_to_update:
                self.librenms_db_client.update_data("ports", [data_to_update], [("port_id", data["id"])])
            port_id = data["id"]
        else:
            if "MAC Address" not in data.keys():
                raise InvalidInsertedData("You have to insert atleast MAC for the new interface to be uniquely identified.")
            if data_to_update:
                data_to_update["device_id"] = data["deviceId"]
                self.librenms_db_client.insert_data([data_to_update], "ports")
                new_record_id = self.librenms_db_client.get_data("ports", [("ifPhysAddress", data["MAC Address"])])[0]["port_id"]
                data_to_return.update({"id": new_record_id, "Interface ID": new_record_id})
                port_id = new_record_id

        if "IP Address" in data.keys():
            self.__insert_ip_addr_record(data["IP Address"], port_id)
        return data_to_return

    def __update_table_arp(self, data: dict):
        """TODO: maybe remove IP addressing creation? and make it same as MAC"""
        data_to_update = {}
        data_to_return = {}

        for key, value in data.items():
            if key == "MAC Address":
                self.__check_mac_addr_validity(value, True)
                data_to_update["mac_address"] = value
            if key == "IP Address":
                self.__check_ip_addr_validity(value)
                ip_addr_parts = value.split("/")
                if not self.__check_ip_addr_existence(ip_addr_parts[0]):
                    raise InvalidInsertedData("IP address does not exist on any device/interface.")
                data_to_update["ipv4_address"] = value.split("/")[0]
            if key == "Interface name":
                port_records = self.librenms_db_client.get_data("ports", [("device_id", data["deviceId"])])
                port_id = ""
                for record in port_records:
                    if record["ifName"] == value:
                        port_id = record["port_id"]
                        break
                if not port_id:
                    raise InvalidInsertedData("Interface name you entered does not belong to any interface on this device.")
                data_to_update["port_id"] = port_id
                data_to_return["Interface ID"] = port_id

        if "id" not in data.keys():
            for colname in ["MAC Address", "IP Address", "Interface name"]:
                if colname not in data.keys():
                    raise InvalidInsertedData("You must enter all optional columns.")
            data_to_update["context_name"] = ""  # this is needed because librenms
            self.librenms_db_client.insert_data([data_to_update], "ipv4_mac")
            record_id = self.librenms_db_client.get_data("ipv4_mac", [(key, value) for key, value in data_to_update.items()])[-1]["id"]
            data_to_return["id"] = record_id
        else:
            if data_to_update:
                self.librenms_db_client.update_data("ipv4_mac", [data_to_update], [("id", data["id"])])

        return data_to_return

    def __check_vlan_validity(self, vlan):
        vlan_number = int(vlan)
        if len(str(vlan_number)) > 11:  # remove trailing 0's
            raise InvalidInsertedData("VLAN number you entered is too long.")

    def __get_vlan_id(self, vlan: str, device_id: int) -> int:
        """Returns vlan id from DB. If no record exists for given vlan,
        insert it and return the new ID."""
        self.__check_vlan_validity(vlan)
        vlan_records = self.librenms_db_client.get_data("vlans", [("vlan_vlan", vlan)])
        if not vlan_records:
            self.librenms_db_client.insert_data([{"vlan_vlan": vlan, "device_id": device_id}], "vlans")
            vlan_record = self.librenms_db_client.get_data("vlans", [("vlan_vlan", vlan)])[-1]
            vlan_id = vlan_record["vlan_id"]
        else:
            vlan_id = vlan_records[-1]["vlan_id"]

        return vlan_id

    def __update_table_mac(self, data: dict):
        data_to_update = {}
        data_to_return = {}

        for key, value in data.items():
            if key == "Destination IF MAC":  # TODO: make generic method for interfaces and MACs and use everywhere
                port_records = self.librenms_db_client.get_data("ports", [("ifPhysAddress", value)])
                if not port_records:
                    raise InvalidInsertedData("MAC address you entered does not belong to any device/interface.")
                valid_port_record = port_records[-1]
                device_record = self.librenms_db_client.get_data("devices", [("device_id", valid_port_record["device_id"])])[0]
                data_to_update["mac_address"] = value
                data_to_return.update({
                    "Destination IF ID": valid_port_record["port_id"],
                    "Destination IF MAC": value,
                    "Destination IF name": valid_port_record["ifName"],
                    "Destination device": device_record["sysName"]
                })

            if key == "Local IF MAC":
                port_records = self.librenms_db_client.get_data("ports", [("ifPhysAddress", value), ("device_id", data["deviceId"])])
                if not port_records:
                    raise InvalidInsertedData("MAC address you entered does not belong to any interface on this device.")
                valid_port_record = port_records[0]
                data_to_update["port_id"] = valid_port_record["port_id"]
                data_to_return.update({
                    "Local IF ID": valid_port_record["port_id"],
                    "Local IF name": valid_port_record["ifName"],
                    "Local IF MAC": value
                })

        if "id" not in data.keys():
            for colname in ["VLAN", "Local IF MAC", "Destination IF MAC"]:
                if colname not in data.keys():
                    raise InvalidInsertedData("You must enter all optional columns.")
            data_to_update["device_id"] = data["deviceId"]

            vlan_id = self.__get_vlan_id(data["VLAN"], data["deviceId"])
            data_to_update["vlan_id"] = vlan_id

            self.librenms_db_client.insert_data([data_to_update], "ports_fdb")
            record_id = self.librenms_db_client.get_data("ports_fdb", [(key, value) for key, value in data_to_update.items()])[-1]["ports_fdb_id"]

            data_to_return["id"] = record_id
        else:
            if "VLAN" in data.keys():
                vlan_id = self.__get_vlan_id(data["VLAN"], data["deviceId"])
                data_to_update["vlan_id"] = vlan_id
            if data_to_update:
                self.librenms_db_client.update_data("ports_fdb", [data_to_update], [("ports_fdb_id", data["id"])])

        return data_to_return

    def __update_table_routing(self, data: dict):
        data_to_update = {}
        data_to_return = {}

        for key, value in data.items():
            if key == "Destination":
                if not self.__check_network_existence(value):
                    raise InvalidInsertedData("Network (destination) does not exist.")
                ip_addr_split = value.split("/")
                data_to_update["inetCidrRouteDest"] = ip_addr_split[0]
                data_to_update["inetCidrRoutePfxLen"] = ip_addr_split[1]
            if key == "Nexthop":
                if not self.__check_ip_addr_existence(value):
                    raise InvalidInsertedData("Nexthop address does not exist on any device/interface.")
                data_to_update["inetCidrRouteNextHop"] = value

                if value != "0.0.0.0":
                    nexthop_record = self.librenms_db_client.get_data("ipv4_addresses", [("ipv4_address", value)])[0]
                    port_record = self.librenms_db_client.get_data("ports", [("port_id", nexthop_record["port_id"])])[0]
                    data_to_return["Nexthop name"] = port_record["ifName"]
            if key == "Interface name":
                port_records = self.librenms_db_client.get_data("ports", [("device_id", data["deviceId"])])
                port_id = ""
                for record in port_records:
                    if record["ifName"] == value:
                        port_id = record["port_id"]
                        break
                if not port_id:
                    raise InvalidInsertedData("Interface name you entered does not belong to any interface on this device.")
                data_to_update["port_id"] = port_id
                data_to_return["Interface ID"] = port_id

        if "id" not in data.keys():
            for colname in ["Destination", "Nexthop", "Interface name"]:
                if colname not in data.keys():
                    raise InvalidInsertedData("You must enter all optional columns.")
            data_to_update["device_id"] = data["deviceId"]
            insert_into_table_route(self.librenms_db_client, data_to_update)
            record_id = self.librenms_db_client.get_data("route", [(key, value) for key, value in data_to_update.items()])[-1]["route_id"]

            data_to_return["id"] = record_id
        else:
            if data_to_update:
                self.librenms_db_client.update_data("route", [data_to_update], [("route_id", data["id"])])

        return data_to_return

    def __update_table_dp(self, data: dict) -> dict:
        data_to_update = {}
        data_to_return = {}

        for key, value in data.items():
            if key == "Remote IF ID":  # TODO: make generic method for interfaces and MACs and use everywhere
                port_records = self.librenms_db_client.get_data("ports", [("port_id", value)])
                if not port_records:
                    raise InvalidInsertedData("Interface ID you entered does not belong to any device/interface.")
                valid_port_record = port_records[-1]
                device_id = valid_port_record["device_id"]
                device_record = self.librenms_db_client.get_data("devices", [("device_id", valid_port_record["device_id"])])[0]

                port_id = value
                port_name = valid_port_record["ifName"]
                mac_addr = valid_port_record["ifPhysAddress"]
                device_name = device_record["sysName"]
                device_version = device_record["sysDescr"]

                data_to_update.update({
                    "remote_hostname": device_name,
                    "remote_device_id": device_id,
                    "remote_port": port_name,
                    "remote_version": device_version,
                    "remote_port_id": port_id
                })
                data_to_return.update({
                    "Remote IF ID": port_id,
                    "Remote IF MAC": mac_addr,
                    "Remote IF name": port_name,
                    "Remote device": device_name
                })

            if key == "Local IF ID":
                port_records = self.librenms_db_client.get_data("ports", [("port_id", value), ("device_id", data["deviceId"])])
                if not port_records:
                    raise InvalidInsertedData("Interface ID you entered does not belong to any interface on this device.")
                valid_port_record = port_records[-1]

                port_id = value
                port_name = valid_port_record["ifName"]
                mac_addr = valid_port_record["ifPhysAddress"]
                device_id = valid_port_record["device_id"]

                data_to_update.update({
                    "active": 1,
                    "local_port_id": port_id,
                    "local_device_id": device_id
                })
                data_to_return.update({
                    "Local IF ID": port_id,
                    "Local IF name": port_name,
                    "Local IF MAC": mac_addr
                })

        if "id" not in data.keys():
            for colname in ["Local IF ID", "Remote IF ID"]:
                if colname not in data.keys():
                    raise InvalidInsertedData("You must enter all optional columns.")

            self.librenms_db_client.insert_data([data_to_update], "links")
            record_id = self.librenms_db_client.get_data("links", [(key, value) for key, value in data_to_update.items()])[-1]["id"]

            data_to_return["id"] = record_id

            relations_ids_records = self.topology_db_client.get_data("relations", [])
            relations_ids = [record["id"] for record in relations_ids_records]
            new_relation_id = max(relations_ids) + 1

            self.topology_db_client.insert_data([
                {
                    "id": new_relation_id,
                    "source": data_to_update["local_device_id"],
                    "target": data_to_update["remote_device_id"],
                    "source_if": data_to_update["local_port_id"],
                    "target_if": data_to_update["remote_port_id"]
                }
            ], "relations")
        else:
            if data_to_update:
                self.librenms_db_client.update_data("links", [data_to_update], [("id", data["id"])])

        return data_to_return

    def update_devices(self, req_json: dict) -> dict:
        table_name = req_json.pop("table")
        match table_name:
            case "devices":
                return self.__update_table_devices(req_json)
            case "details":
                return self.__update_table_device_details(req_json)
            case "arp_table":
                return self.__update_table_arp(req_json)
            case "interfaces":
                return self.__update_table_interfaces(req_json)
            case "mac_table":
                return self.__update_table_mac(req_json)
            case "routing_table":
                return self.__update_table_routing(req_json)
            case "dp_table":
                return self.__update_table_dp(req_json)
            case _:
                raise NotImplementedError("This update option is not implemented...")

    def __purge_device_from_topology(self, device_id: int) -> None:
        """Removes device from DB `topology` completely, including relations,
        inf. systems, paths...
        TODO: maybe move somewhere else?"""
        relation_records = []
        for query in ["source", "target"]:
            relation_records.extend(self.topology_db_client.get_data("relations", [(query, device_id)]))

        path_data = []
        for record in relation_records:
            relation_id = record["id"]
            # gather all path ids
            path_records = self.topology_db_client.get_data("paths", [("relation_id", relation_id)])
            for path_record in path_records:
                path_id = path_record["path_id"]
                group_id = path_record["application_group_id"]
                path_group_tuple = (path_id, group_id)
                if path_group_tuple not in path_data:
                    path_data.append(path_group_tuple)
            # remove records, we don't need them anymore
            self.topology_db_client.remove_data([("id", relation_id)], "relations")

        # remove paths, appl. groups, and inf. systems
        for path_record in path_data:
            path.remove_path({"pathId": path_record[0], "groupId": path_record[1]})

        # remove device
        self.topology_db_client.remove_data([("id", device_id)], "nodes")

    def __delete_row_table_devices(self, data: dict) -> None:
        """Deletes records from all tables that refer to given
        device and it's ports."""
        device_id = data["id"]

        # get all ports of device
        port_records = self.librenms_db_client.get_data("ports", [("device_id", device_id)])
        for port_record in port_records:
            port_id = port_record["port_id"]
            mac_address = port_record["ifPhysAddress"]

            # delete data from `ipv4_mac`
            self.librenms_db_client.remove_data([("port_id", port_id)], "ipv4_mac")
            self.librenms_db_client.remove_data([("mac_address", mac_address)], "ipv4_mac")
            # delete data from `links`
            self.librenms_db_client.remove_data([("local_port_id", port_id)], "links")
            self.librenms_db_client.remove_data([("remote_port_id", port_id)], "links")
            # delete data from `ports_fdb`
            self.librenms_db_client.remove_data([("port_id", port_id)], "ports_fdb")
            self.librenms_db_client.remove_data([("mac_address", mac_address)], "ports_fdb")
            # delete data from `route`
            self.librenms_db_client.remove_data([("port_id", port_id)], "route")
            ip_addr_records = self.librenms_db_client.get_data("ipv4_addresses", [("port_id", port_id)])
            for ip_addr_record in ip_addr_records:
                ip_addr = ip_addr_record["ipv4_address"]
                self.librenms_db_client.remove_data([("inetCidrRouteNextHop", ip_addr)], "route")
            # delete data from `ipv4_addresses`
            self.librenms_db_client.remove_data([("port_id", port_id)], "ipv4_addresses")

        # delete device data from table `devices`
        self.librenms_db_client.remove_data([("device_id", device_id)], "devices")

        # delete device `topology` DB
        self.__purge_device_from_topology(device_id)

    def __delete_row_arp_table(self, data: dict) -> None:
        record_id = data["id"]

        # delete record from arp table
        self.librenms_db_client.remove_data([("id", record_id)], "ipv4_mac")

    def __delete_row_interfaces(self, data: dict) -> None:
        port_id = data["id"]

        # delete port ip address
        self.librenms_db_client.remove_data([("port_id", port_id)], "ipv4_addresses")
        # delete port record
        self.librenms_db_client.remove_data([("port_id", port_id)], "ports")

    def __delete_row_mac_table(self, data: dict) -> None:
        record_id = data["id"]

        # delete mac table record
        self.librenms_db_client.remove_data([("ports_fdb_id", record_id)], "ports_fdb")

    def __delete_row_routing_table(self, data: dict) -> None:
        record_id = data["id"]

        # delete routing table record
        self.librenms_db_client.remove_data([("route_id", record_id)], "route")

    def __delete_row_table_links(self, data: dict) -> None:
        record_id = data["id"]

        # delete DP record
        self.librenms_db_client.remove_data([("id", record_id)], "links")

        data_to_delete = [("source_if", data["Local IF ID"]),
                          ("target_if", data["Remote IF ID"])]
        record_to_delete = self.topology_db_client.get_data("relations", data_to_delete)[0]

        self.topology_db_client.remove_data([("id", record_to_delete["id"])], "relations")
        self.topology_db_client.remove_gaps_in_ids("relations")

    def delete_row(self, req_json: dict) -> dict:
        table_name = req_json.pop("table")
        match table_name:
            case "devices":
                self.__delete_row_table_devices(req_json)
            case "arp_table":
                self.__delete_row_arp_table(req_json)
            case "interfaces":
                self.__delete_row_interfaces(req_json)
            case "mac_table":
                self.__delete_row_mac_table(req_json)
            case "routing_table":
                self.__delete_row_routing_table(req_json)
            case "dp_table":
                self.__delete_row_table_links(req_json)
            case _:
                raise NotImplementedError("This delete option is not implemented...")
