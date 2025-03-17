import React, { Dispatch } from "react";
import { ConfigProvider, Space, Table, Tag } from "antd";

import { PathTableItem } from "./types";

const { Column } = Table;

interface InterfacePathTable {
  items: PathTableItem[];
  setPathTableData: Dispatch<PathTableItem[]>;
}

const PathTable: React.FC<InterfacePathTable> = ({
  items,
  setPathTableData,
}) => (
  <ConfigProvider
    theme={{
      components: {
        Table: {
          headerBorderRadius: 0,
        },
      },
    }}
  >
    <Table pagination={false} dataSource={items}>
      <Column title="Path name" dataIndex="name" key="name" />
      <Column title="Confidentality" dataIndex="confidentalityValue" key="confidentalityValue" />
      <Column title="Integrity" dataIndex="integrityValue" key="integrityValue" />
      <Column title="Availability" dataIndex="availabilityValue" key="availabilityValue" />
      <Column
        title="Color"
        dataIndex="color"
        key="color"
        render={(color: string) => (
          <>
            <Tag color={color} key="tag">
              {color}
            </Tag>
          </>
        )}
      />
      <Column
        title="Action"
        key="action"
        render={(item: PathTableItem) => (
          <Space size="middle">
            <a
              onClick={() => {
                item.fun();
                setPathTableData(
                  items.filter((newItem) => newItem.pathId !== item.pathId),
                );
              }}
            >
              Delete
            </a>
          </Space>
        )}
      />
    </Table>
  </ConfigProvider>
);

export default PathTable;
