class NotFoundError(Exception):
    pass


class MultipleOccurrences(Exception):
    pass


class PathNotFound(Exception):
    pass


class UndefinedDeviceType(Exception):
    pass


class DifferentNetworksError(Exception):
    pass


class VirtualInterfaceFound(Exception):
    pass


class DuplicitDBEntry(Exception):
    pass


class CommonDBError(Exception):
    pass


class NotImplementedError(Exception):
    pass


class InvalidInsertedData(Exception):
    pass


class MissingFKError(CommonDBError):
    def __init__(self, table_name: str, record_index: int, key: str):
        self.table_name = table_name
        self.record_index = record_index
        self.key = key

    def __str__(self):
        return f"FK does not exist for table: {self.table_name}, record: {self.record_index}, key: {self.key}"
