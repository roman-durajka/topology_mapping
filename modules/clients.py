import mariadb


class MariaDBClient:
    """Client to establish connection with MariaDB database and offer basic statement actions."""
    def __init__(self):
        self.connection = mariadb.connect(
            database="librenms",
            user="root",
            password="password",
            host="db_con"
        )
        self.cursor = self.connection.cursor()

    def __parse_cursor_data(self, table_name, *args):
        """
        Parses cursor data.
        :param table_name: name of table to query
        :param args: optional to specify column names
        :return:
        """
        parsed_data = []
        records = [record for record in self.cursor]

        column_names = args
        if not args:
            statement = f"SHOW COLUMNS FROM {table_name}"
            self.cursor.execute(statement)
            column_names = [column_name for column_name in self.cursor]
            column_names = [column_name[0] for column_name in column_names]

        for record in records:
            row = {}
            for index, data in enumerate(record):
                row.update({column_names[index]: data})
            parsed_data.append(row)

        return parsed_data

    def get_data(self, table_name, queries: list = None, *args):
        """
        Parses and returns data from database based on table name, column names and queries.
        :param table_name: name of table
        :param queries: list of tuples to query only specific data, fe. [("color", "red)] -> color has to be red
        :param args: optional args to specify which columns data to return
        :return:
        """
        statement = f"SELECT {','.join(args) if args else '*'} from {table_name}"
        if queries:
            statement += f" WHERE"
            first = True
            for query in queries:
                if not first:
                    statement += f" AND"
                statement += f" {query[0]}=\'{query[1]}\'"
                first = False

        self.cursor.execute(statement)

        return self.__parse_cursor_data(table_name, *args)
