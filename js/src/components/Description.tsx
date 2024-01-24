import React from "react";
import { Badge, Descriptions } from "antd";
import type { DescriptionsProps } from "antd";

interface InterfaceDescription {
  items: DescriptionsProps["items"];
}

const CustomDescription: React.FC<InterfaceDescription> = ({ items }) => (
  <Descriptions
    bordered
    contentStyle={{ border: "1px solid !important" }}
    items={items}
  />
);

export default CustomDescription;
