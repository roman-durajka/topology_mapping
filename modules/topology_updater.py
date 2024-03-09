from modules.clients import MariaDBClient
from modules.exceptions import DuplicitDBEntry, CommonDBError


SCHEME_ATTRS_IN_ORDER = ["devices", "ports", "ipv4_networks", "ipv4_addresses", "ipv4_mac", "links", "ports_fdb", "route", "vlans"]


COLUMN_DATA_TYPE_MAP = {
    str: ["varchar", "text", "varbinary"],
    int: ["int", "tinyint", "double", "bigint"]
}


def pad_forced_attributes(data_to_insert: list[dict], table_name: str):
    """Adds some necessarry attributes required by librenms, but not really
    needed to be put in by user. Without them it would not be possible to
    insert data into DB, but also it would not be wise to ask user to
    fill in fe. status_reason etc..."
    """
    if table_name == "devices":
        for record in data_to_insert:
            record.update({"status_reason": ""})
    if table_name == "ipv4_mac":
        for record in data_to_insert:
            record.update({"context_name": ""})
    if table_name == "links":
        for record in data_to_insert:
            record.update({"remote_version": "",
                           "remote_port": "",
                           "remote_hostname": ""})
    if table_name == "route":
        for record in data_to_insert:
            record.update({"inetCidrRouteIfIndex": 0,
                           "inetCidrRouteType": 0,
                           "inetCidrRouteProto": 0,
                           "inetCidrRouteNextHopAS": 0,
                           "inetCidrRouteMetric1": 0,
                           "inetCidrRouteDestType": "ipv4",
                           "inetCidrRouteNextHopType": "ipv4",
                           "inetCidrRoutePolicy": ""})


def check_scheme_validity(db_client: MariaDBClient, data_to_insert: list[dict], table_name: str):
    # check for NOT NULL attributes
    not_null_columns = db_client.get_columns(table_name, True, True)
    for column_name in not_null_columns:
        for index, record in enumerate(data_to_insert):
            if column_name not in record.keys():
                raise CommonDBError(f"NOT NULL column {column_name} missing in record {index} for table {table_name}")

    # check for not allowed column names and data types
    all_columns = db_client.get_columns(table_name)
    column_data_types = db_client.get_column_data_types(table_name)

    for index, record in enumerate(data_to_insert):
        for key in record.keys():
            if key not in all_columns:
                raise CommonDBError(f"Column name {key} not allowed here in record {index} for table {table_name}")
            if column_data_types[key] not in COLUMN_DATA_TYPE_MAP[type(record[key])]:
                raise CommonDBError(f"Wrong data type of column {key} in record {index} for table {table_name}")

    # check for duplicities
    pk_columns = db_client.get_columns(table_name, False, False, True)

    query_list = []
    for pk in pk_columns:
        if pk in record.keys():
            query_list.append((pk, record[pk]))

    if query_list:
        query_result = db_client.get_data(table_name, query_list)
        if query_result:
            raise DuplicitDBEntry("You are trying to insert data that is already in the database")


def update_db_from_scheme(scheme_json: dict, skip_checks: bool = False):
    db_client = MariaDBClient("librenms")

    for attr in SCHEME_ATTRS_IN_ORDER:
        data_to_insert = scheme_json[attr]

        if data_to_insert:
            # add NOT NULL attributes not important for the user but needed by librenms
            pad_forced_attributes(data_to_insert, attr)

            # skip when uploading data second time
            if skip_checks:
                continue

            # check validity
            check_scheme_validity(db_client, data_to_insert, attr)

    # insert data
    for attr in SCHEME_ATTRS_IN_ORDER:
        data_to_insert = scheme_json[attr]

        if data_to_insert:
            try:
                db_client.insert_data(data_to_insert, attr, False)
                db_client.commit()
            except Exception as e:
                db_client.rollback()
                raise e

    # erase some tables in topology DB so that DP algorithm can be run with new data
    topology_db_client = MariaDBClient("topology")
    topology_db_client.remove_data([("1", "1")], "relations")
    topology_db_client.remove_data([("1", "1")], "nodes")
