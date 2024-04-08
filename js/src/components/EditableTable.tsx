import React, { ReactNode, useState } from "react";
import {
  Button,
  Form,
  Input,
  InputNumber,
  Popconfirm,
  Table,
  Typography,
} from "antd";
import { PlusOutlined } from "@ant-design/icons";
import { ColumnItem } from "./types";

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
  allowAdditions?: boolean;
  title?: ReactNode;
}

const EditableTable: React.FC<InterfaceEditableTable> = ({
  data,
  columns,
  onSave,
  allowAdditions,
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

  const tableColumnsFun: () => object[] = () => {
    let allowEditing: boolean = false;
    Object.keys(columns).map((columnKey: string) => {
      if (columns[columnKey]["editable"]) {
        allowEditing = true;
      }
    });

    if (!allowEditing) {
      return columns;
    }

    return [
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
            <span>
              <Typography.Link
                disabled={editingKey !== ""}
                onClick={() => edit(record)}
                style={{ marginRight: 8 }}
              >
                Edit
              </Typography.Link>
              <Popconfirm
                title="Sure to delete?"
                onConfirm={() => {
                  return;
                }}
              >
                <a>Delete</a>
              </Popconfirm>
            </span>
          );
        },
      },
    ];
  };

  const mergedColumns = tableColumnsFun().map(
    (col: { [index: string]: any }) => {
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
    },
  );

  const expandedRowRender: (props: object) => ReactNode = (props: object) => {
    if (props && "subComponent" in props) {
      return props["subComponent"] as ReactNode;
    }
  };

  const isExpandable: () => boolean = () => {
    let expandable = false;
    data.map((item: object) => {
      if ("subComponent" in item) {
        expandable = true;
      }
    });

    if (expandable) {
      return true;
    }
    return false;
  };

  // appends new row to table for user to add new data
  const addNewRow: ReactNode | null = (() => {
    if (!allowAdditions) {
      return null;
    }

    return (
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          padding: "12px",
          border: "1px solid #e8e8e8",
          borderTop: "none",
          backgroundColor: "#ffffff",
          marginInline: "32px -16px",
          marginTop: "18px",
        }}
      >
        <Button
          icon={<PlusOutlined />}
          type="text"
          className="ant-table-bordered"
        />
      </div>
    );
  })();

  return (
    <Form form={form} component={false}>
      <Table
        expandable={isExpandable() ? { expandedRowRender } : undefined}
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
      {addNewRow}
    </Form>
  );
};

export default EditableTable;
