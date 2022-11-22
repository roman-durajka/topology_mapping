from modules.clients import MariaDBClient
from entities import Interface, Relation, RelationsContainer


def check_device_mac_addr_validity(db_client: MariaDBClient, device_info: dict):
    """Checks if device has any other MAC addressess associated with it. Return True only if given MAC address matches
    the one found in other DB tables, or if there is no other MAC address found for the device.
    Some records (devices) in table 'ipv4_mac' have duplicate mac addresses. One of possible ways to resolve this
    conflict is to check which record is really correct. To find out record validity, this function crawls other tables
    to find any clue of given record validity.
    :param db_client: db client
    :param device_info: dict with info about device {"mac_address": 123, "device_id": 1, "port_id": 1}
    :return: bool
    """
    queries = [("port_id", device_info["port_id"])]
    found_mac_address = db_client.get_data("ports", queries, "ifPhysAddress")[0]["ifPhysAddress"]

    if device_info["mac_address"] == found_mac_address or not found_mac_address:
        return True
    return False


def extract_mac():
    db_client = MariaDBClient()
    relations = RelationsContainer()

    records = db_client.get_data("ports_fdb", None, "device_id", "port_id", "mac_address")  # fetching all records from db, but only necessary columns

    for record in records:
        #  get info about source device (switch)
        source_device_port_id = record["port_id"]

        ####################################################
        if source_device_port_id == 0:  # ??????????????????
            continue
        ####################################################

        source_device_int_name = db_client.get_data("ports", [("port_id", source_device_port_id)], "ifName")[0]["ifName"]
        source_device_int_ip_addr = db_client.get_data("ipv4_addresses", [("port_id", source_device_port_id)], "ipv4_address")
        if source_device_int_ip_addr:  # some interfaces don't have ip address
            source_device_int_ip_addr = source_device_int_ip_addr[0]["ipv4_address"]
        else:
            source_device_int_ip_addr = None
        source_interface = Interface(source_device_int_name, record["device_id"], source_device_int_ip_addr)

        #  get info about destination device
        destination_device_mac = record["mac_address"]
        destination_device_ports_info = db_client.get_data("ports", [("ifPhysAddress", destination_device_mac)], "ifName", "device_id", "port_id")
        if destination_device_ports_info:  # device with mac on interface
            destination_device_ports_info = destination_device_ports_info[0]
            destination_device_port_id = destination_device_ports_info["port_id"]
            destination_device_int_name = destination_device_ports_info["ifName"]
            destination_device_id = destination_device_ports_info["device_id"]
            destination_device_int_ip_addr = db_client.get_data("ipv4_addresses", [("port_id", destination_device_port_id)],
                                                                "ipv4_address")

            if destination_device_int_ip_addr:  # some interfaces don't have ip address
                destination_device_int_ip_addr = destination_device_int_ip_addr[0]["ipv4_address"]
            else:
                destination_device_int_ip_addr = None
        else:  # device without mac on interface (PC, R ?)
            #  beware of multiple addresses in ipv4_mac !!!!!!!!! TODO:
            destination_device_ports_info_list = db_client.get_data("ipv4_mac", [("mac_address", destination_device_mac)], "mac_address", "device_id", "port_id", "ipv4_address")
            # je to router nie pecko
            if not destination_device_ports_info_list:
                #  je v mac tabulke ale nikde inde?
                continue

            if len(destination_device_ports_info_list) > 1:
                device_ip_address = destination_device_ports_info_list[0]["ipv4_address"]
                match = True
                for destination_device_ports_info in destination_device_ports_info_list:  # if all ipv4 addr. match, they're the same device
                    if destination_device_ports_info["ipv4_address"] != device_ip_address:
                        match = False

                if not match:
                    valid_field = None
                    for destination_device_ports_info in destination_device_ports_info_list:
                        if check_device_mac_addr_validity(db_client, destination_device_ports_info):
                            valid_field = destination_device_ports_info
                            break

                    destination_device_ports_info = valid_field

                    if not valid_field:
                        #  can't find valid MAC owner
                        raise KeyError
            else:
                destination_device_ports_info = destination_device_ports_info_list[0]

            destination_device_id = destination_device_ports_info["device_id"]
            destination_device_int_ip_addr = destination_device_ports_info["ipv4_address"]
            destination_device_port_id = destination_device_ports_info["port_id"]
            destination_device_int_name = db_client.get_data("ports", [("port_id", destination_device_port_id)], "ifName")[0]["ifName"]

        destination_interface = Interface(destination_device_int_name, destination_device_id, destination_device_int_ip_addr)

        relations.add(Relation(source_interface, destination_interface))

    return str(relations)
        #  je v mac tabulke ale zariadenie nieje 00e02b000001, 00000c9ff063, 00000c9ff014, 00000c9ff00a, 00e02b000001 - preskocime
        #  v tabulke pre mac adresy sa vztahuje k viacerym zariadeniam 00000c9ff014 - zoberiem prve
