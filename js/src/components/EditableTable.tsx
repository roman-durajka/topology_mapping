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
import { ColumnItem, StringIndexedObject } from "./types";
import {useUnsavedChangesGlobal, useUnsavedChangesRouter} from "./unsavedChanges.tsx";

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
  onDelete?: (...args: any) => void;
  onAdd?: (...args: any) => void;
  title?: ReactNode;
}

const EditableTable: React.FC<InterfaceEditableTable> = ({
  data,
  columns,
  onSave,
  onDelete,
  onAdd,
  title,
}) => {
  const [form] = Form.useForm();
  const [tableData, setTableData] = useState(data);
  const [editingKey, setEditingKey] = useState<string | React.Key>("");
  const [isDirty, setIsDirty] = useState(false);

  const isEditing = (record: StringIndexedObject) => record.key === editingKey;

  const edit = (
    record:
      | Partial<StringIndexedObject>
      | (StringIndexedObject & { key: React.Key }),
  ) => {
    form.setFieldsValue(record);
    setEditingKey(record.key);
    setIsDirty(true);
  };

  const cancel = () => {
    setEditingKey("");
    setIsDirty(false);
  };

  const save = async (key: React.Key) => {
    try {
      const row = (await form.validateFields()) as Item;

      const newData: StringIndexedObject[] = [...tableData];
      const index = newData.findIndex(
        (item: StringIndexedObject) => key === item.key,
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
      onSave(newData[index], index, (responseData: StringIndexedObject) => {
        const updatedData: StringIndexedObject = {
          ...newData[index],
          ...responseData,
        };

        const updatedNewData: StringIndexedObject[] = [...newData];
        updatedNewData[index] = updatedData;

        setTableData([...updatedNewData]);
      });
    } catch (errInfo) {
      console.log("Validate Failed:", errInfo);
    }
    setIsDirty(false);
  };

  const tableColumnsFun: () => object[] = () => {
    let allowEditing: boolean = false;
    columns.map((column: ColumnItem) => {
      if (column["editable"]) {
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
        render: (_: any, record: StringIndexedObject, index: number) => {
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
              {onDelete && (
                <Popconfirm
                  title="Sure to delete?"
                  onConfirm={() =>
                    onDelete(index, () => {
                      const newData = tableData.filter(
                        (_, tableIndex) => tableIndex !== index,
                      );
                      setTableData([...newData]);
                    })
                  }
                >
                  <a>Delete</a>
                </Popconfirm>
              )}
            </span>
          );
        },
      },
    ];
  };

  const mergedColumns = tableColumnsFun().map((col: StringIndexedObject) => {
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
    if (!onAdd) {
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
          onClick={() =>
            onAdd((newRow: StringIndexedObject) => {
              newRow["key"] = `newRow${tableData.length}`;
              setTableData([...tableData, newRow]);
              edit(newRow);
            })
          }
        />
      </div>
    );
  })();

  useUnsavedChangesGlobal(isDirty);
  useUnsavedChangesRouter(isDirty);

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
