from modules.clients import MariaDBClient
from modules.exceptions import DuplicitDBEntry, CommonDBError, MissingFKError

import ipaddress


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

        # erase some tables in topology DB so that DP algorithm can be run with new data
        topology_db_client = MariaDBClient("topology")
        topology_db_client.remove_data([("1", "1")], "relations")
        topology_db_client.remove_data([("1", "1")], "nodes")
