import React from "react";
import { Space, Table, Tag } from "antd";

import { PathTableItem } from "./types";

const { Column } = Table;

interface InterfacePathTable {
  items: PathTableItem[];
}

const PathTable: React.FC<InterfacePathTable> = ({ items }) => (
  <Table dataSource={items}>
    <Column title="Path name" dataIndex="name" key="name" />
    <Column title="Asset value" dataIndex="assetValue" key="assetValue" />
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
          <a onClick={item.fun}>Delete</a>
        </Space>
      )}
    />
  </Table>
);

export default PathTable;
