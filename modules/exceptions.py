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
