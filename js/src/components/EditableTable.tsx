import React, { ReactNode, useState } from "react";
import { Form, Input, InputNumber, Popconfirm, Table, Typography } from "antd";
import { ColumnItem, SubColumnGroup } from "./types";

interface Item {
  key: string;
  name: string;
  age: number;
  address: string;
}

interface EditableCellProps extends React.HTMLAttributes<HTMLElement> {
  editing: boolean;
  dataIndex: string;
  title: any;
  inputType: "number" | "text";
  record: object;
  index: number;
  children: React.ReactNode;
}

const EditableCell: React.FC<EditableCellProps> = ({
  editing,
  dataIndex,
  title,
  inputType,
  record,
  index,
  children,
  ...restProps
}) => {
  const inputNode = inputType === "number" ? <InputNumber /> : <Input />;

  return (
    <td {...restProps}>
      {editing ? (
        <Form.Item
          name={dataIndex}
          style={{ margin: 0 }}
          rules={[
            {
              required: false,
              message: `Please Input ${title}!`,
            },
          ]}
        >
          {inputNode}
        </Form.Item>
      ) : (
        children
      )}
    </td>
  );
};

interface InterfaceEditableTable {
  data: object[];
  columns: ColumnItem[];
  onSave: (...args: any) => void;
  subColumns?: SubColumnGroup[];
  title?: ReactNode;
}

const EditableTable: React.FC<InterfaceEditableTable> = ({
  data,
  columns,
  onSave,
  subColumns,
  title,
}) => {
  const [form] = Form.useForm();
  const [tableData, setTableData] = useState(data);
  const [editingKey, setEditingKey] = useState<string | React.Key>("");

  const isEditing = (record: { [index: string]: any }) =>
    record.key === editingKey;

  const edit = (
    record:
      | Partial<{ [index: string]: any }>
      | ({ [index: string]: any } & { key: React.Key }),
  ) => {
    form.setFieldsValue(record);
    setEditingKey(record.key);
  };

  const cancel = () => {
    setEditingKey("");
  };

  const save = async (key: React.Key) => {
    try {
      const row = (await form.validateFields()) as Item;

      const newData = [...tableData];
      const index = newData.findIndex(
        (item: { [index: string]: any }) => key === item.key,
      );
      if (index > -1) {
        const item = newData[index];
        newData.splice(index, 1, {
          ...item,
          ...row,
        });
        setTableData(newData);
        setEditingKey("");
      } else {
        newData.push(row);
        setTableData(newData);
        setEditingKey("");
      }
      onSave(newData[index]);
    } catch (errInfo) {
      console.log("Validate Failed:", errInfo);
    }
  };

  const tableColumns: ColumnItem[] | { [index: string]: any }[] = [
    ...columns,
    {
      title: "operation",
      dataIndex: "operation",
      render: (_: any, record: { [index: string]: any }) => {
        const editable = isEditing(record);
        return editable ? (
          <span>
            <Typography.Link
              onClick={() => save(record.key)}
              style={{ marginRight: 8 }}
            >
              Save
            </Typography.Link>
            <Popconfirm title="Sure to cancel?" onConfirm={cancel}>
              <a>Cancel</a>
            </Popconfirm>
          </span>
        ) : (
          <Typography.Link
            disabled={editingKey !== ""}
            onClick={() => edit(record)}
          >
            Edit
          </Typography.Link>
        );
      },
    },
  ];

  const mergedColumns = tableColumns.map((col) => {
    if (!col.editable) {
      return col;
    }
    return {
      ...col,
      onCell: (record: object) => ({
        record,
        inputType: col.dataIndex === "age" ? "number" : "text",
        dataIndex: col.dataIndex,
        title: col.title,
        editing: isEditing(record),
      }),
    };
  });

  const expandedRowRender = (props: object) => {
    if (props && "subItems" in props && subColumns) {
      const subItems: any = props["subItems"];
      return (
        <Table columns={subColumns} dataSource={subItems} pagination={false} />
      );
    }
    return undefined;
  };

  return (
    <Form form={form} component={false}>
      <Table
        expandable={{
          expandedRowRender,
        }}
        components={{
          body: {
            cell: EditableCell,
          },
        }}
        bordered
        dataSource={tableData}
        columns={mergedColumns}
        rowClassName="editable-row"
        pagination={false}
        title={title ? () => title : undefined}
      />
    </Form>
  );
};

export default EditableTable;