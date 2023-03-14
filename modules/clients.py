import mariadb


class MariaDBClient:
    def __init__(self):
        self.connection = mariadb.connect(
            database="relations",
            user="user",
            password="password",
            host="0.0.0.0",
            port=3306
        )
        self.cursor = self.connection.cursor()

    def __parse_cursor_data(self, table_name, *args):
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
        #  use args to specify which columns data to return
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
