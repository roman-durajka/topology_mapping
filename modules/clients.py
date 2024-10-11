import mariadb
import json

from modules.exceptions import NotFoundError


class MariaDBClient:
    """Client to establish connection with MariaDB database and offer basic
    statement actions.

    To make connection inside docker container, choose host="db_con". To run
    DB in docker and python API outside docker, choose host="0.0.0.0"."""
    def __init__(self, database):
        self.connection = mariadb.connect(
            database=database,
            user="root",
            password="password",
            host="db_con",
            port=3306
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
        :param queries: list of tuples to query only specific data, fe. [("color", "red")] -> color has to be red
        :param args: optional args to specify which columns data to return
        :return:
        """
        statement = f"SELECT {','.join(args) if args else '*'} from {table_name}"
        if queries:
            statement += " WHERE"
            first = True
            for query in queries:
                if not first:
                    statement += " AND"
                statement += f" {query[0]}=\'{query[1]}\'"
                first = False

        try:
            self.cursor.execute(statement)
        except mariadb.Error as error:
            raise NotFoundError("ERROR: Could not execute db statement. Are you sure you loaded all database"
                                f" data correctly? Detailed message: {error}")

        return self.__parse_cursor_data(table_name, *args)

    def insert_data(self, data: list, table_name: str, commit: bool = True):
        for record in data:
            for key, value in record.items():
                if isinstance(value, dict) or isinstance(value, list):
                    record[key] = json.dumps(value)

            columns = list(record.keys())
            values = list(record.values())

            placeholders = ', '.join(['%s'] * len(columns))
            columns = ', '.join(columns)

            query = f"REPLACE INTO {table_name} ({columns}) VALUES ({placeholders});"
            self.cursor.execute(query, values)
        if commit:
            self.connection.commit()

    def remove_data(self, conditions: list[tuple], table_name: str):
        """Removes data from database. Conditions should look like this: [("a", 5), ("b", 6)]"""
        query = f"DELETE FROM {table_name} WHERE"
        values = []
        first_condition = True
        for condition in conditions:
            if not first_condition:
                query += " AND"
            query += f" {condition[0]} = %s"
            values.append(condition[1])
            first_condition = False
        self.cursor.execute(query, values)
        self.connection.commit()

    def update_data(self, table_name: str, data: list, conditions: list[tuple] = None):
        for record in data:
            for key, value in record.items():
                if isinstance(value, (dict, list)):
                    record[key] = json.dumps(value)

            columns = list(record.keys())
            values = list(record.values())

            query = f"UPDATE {table_name} SET"

            first = True
            for index, column in enumerate(columns):
                if not first:
                    query += ","
                query += f" {column} = %s"
                first = False
            if conditions:
                first = True
                query += " WHERE"
                for condition in conditions:
                    if not first:
                        query += " AND"
                    query += f" {condition[0]} = {condition[1]}"
                    first = False

            self.cursor.execute(query, values)
            self.connection.commit()

    def __parse_columns(self, data: list[tuple], without_default: bool, primary_key: bool):
        parsed_data = []

        for record in data:
            auto_increment = "auto_increment" in record[3]
            is_primary_key = record[4] == "PRI"
            if without_default and (record[2] or auto_increment):
                continue
            if primary_key and not is_primary_key:
                continue
            parsed_data.append(record[0])

        return parsed_data

    def get_columns(self, table_name: str, not_null: bool = False, without_default: bool = False, primary_key: bool = False):
        """Returns list of str in format [column_name]."""
        statement = f"SELECT COLUMN_NAME, DATA_TYPE, COLUMN_DEFAULT, EXTRA, COLUMN_KEY FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{table_name}'"
        if not_null:
            statement += " AND IS_NULLABLE = 'NO'"

        try:
            self.cursor.execute(statement)
        except mariadb.Error as error:
            raise NotFoundError("ERROR: Could not execute db statement. Are you sure you loaded all database"
                                f" data correctly? Detailed message: {error}")

        parsed_data = self.__parse_columns(self.cursor.fetchall(), without_default, primary_key)
        return parsed_data

    def __parse_column_data_types(self, data: list[tuple]):
        parsed_data = {}

        for record in data:
            parsed_data.update({record[0]: record[1]})

        return parsed_data

    def get_column_data_types(self, table_name: str):
        """Returns list of str in format [column_name]."""
        statement = f"SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{table_name}'"

        try:
            self.cursor.execute(statement)
        except mariadb.Error as error:
            raise NotFoundError("ERROR: Could not execute db statement. Are you sure you loaded all database"
                                f" data correctly? Detailed message: {error}")

        parsed_data = self.__parse_column_data_types(self.cursor.fetchall())
        return parsed_data

    def remove_gaps_in_ids(self, table_name: str, column_name: str = "id", start_from: int = 0):
        """Re-orders table based on id, removing missing ID values, fe. makes
        ids 1, 2, 3, 5, 6 into 1, 2, 3, 4, 5."""
        data = self.get_data(table_name)
        sorted_data = sorted(data, key=lambda x: x[column_name])

        for index, record in enumerate(sorted_data):
            record[column_name] = index + start_from

        self.remove_data([(1, 1)], table_name)
        self.insert_data(sorted_data, table_name)

    def commit(self):
        self.connection.commit()

    def rollback(self):
        self.connection.rollback()
