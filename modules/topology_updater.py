from modules.clients import MariaDBClient


SCHEME_ATTRS_IN_ORDER = ["devices", "ports", "ipv4_networks", "ipv4_addresses", "ipv4_mac", "links", "ports_fdb", "route", "vlans"]


def update_db_from_scheme(scheme_json: dict):
    db_client = MariaDBClient("librenms")

    for attr in SCHEME_ATTRS_IN_ORDER:
        data_to_insert = scheme_json[attr]

        if data_to_insert:
            if attr == "devices":
                for record in data_to_insert:
                    record.update({"status_reason": ""})
            if attr == "ipv4_mac":
                for record in data_to_insert:
                    record.update({"context_name": ""})
            if attr == "links":
                for record in data_to_insert:
                    record.update({"remote_version": "",
                                   "remote_port": "",
                                   "remote_hostname": ""})
            if attr == "route":
                for record in data_to_insert:
                    record.update({"inetCidrRouteIfIndex": 0,
                                   "inetCidrRouteType": 0,
                                   "inetCidrRouteProto": 0,
                                   "inetCidrRouteNextHopAS": 0,
                                   "inetCidrRouteMetric1": 0,
                                   "inetCidrRouteDestType": "ipv4",
                                   "inetCidrRouteNextHopType": "ipv4",
                                   "inetCidrRoutePolicy": ""})

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
