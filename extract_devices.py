from modules.clients import MariaDBClient
from entities import Device


def extract_devices():
    db_client = MariaDBClient()

    devices = []
    records = db_client.get_data("devices", None, "device_id", "sysName")
    for record in records:
        device = Device(record["device_id"], record["sysName"])
        devices.append(device)

    result = ""
    for device in devices:
        result += f"{str(device)}"

    return result
