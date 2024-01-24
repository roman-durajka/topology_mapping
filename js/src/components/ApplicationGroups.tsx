import { useEffect, useState } from "react";
import { message, Empty, DescriptionsProps } from "antd";

import CustomLayout from "../CustomLayout";
import { messageLoading, messageSuccess } from "../message";
import request from "./Requester";
import CustomDescription from "./Description";
import { ColumnItem, SubColumnGroup, SubColumnItem } from "./types";
import EditableTable from "./EditableTable";

export default function ApplicationGroups() {
  const [messageApi, contextHolder] = message.useMessage();
  const [applicationGroups, setApplicationGroups] = useState({});

  useEffect(() => {
    const responseData: Promise<Response> = request({
      url: "http://localhost:5000/application-groups",
      method: "GET",
    });
    messageLoading(messageApi, "Loading page...");
    responseData
      .then((response) => response.json())
      .then((data) => {
        setApplicationGroups(data.data);
      });
    messageApi.destroy();
    messageSuccess(messageApi, "Page loaded.");
  }, []);

  const columns: ColumnItem[] = [
    {
      title: "process name",
      dataIndex: "processName",
      width: "50%",
      editable: true,
    },
    {
      title: "information systems",
      dataIndex: "informationSystems",
      width: "50%",
      editable: true,
    },
  ];

  //name model os type
  const subColumns: SubColumnGroup[] = [
    {
      title: "Devices",
      children: [
        {
          title: "device name",
          dataIndex: "deviceName",
        },
        {
          title: "model",
          dataIndex: "model",
        },
        {
          title: "operating system",
          dataIndex: "os",
        },
        {
          title: "type",
          dataIndex: "type",
        },
      ],
    },
  ];

  //items for description component
  const items: object[] = Object.keys(applicationGroups).map(
    (dictKey: string, index: number) => {
      const item: object = applicationGroups[dictKey];
      const devices: object[] = Object.keys(item.devices).map(
        (deviceId: string, deviceIndex: number) => {
          const deviceItem: object = item["devices"][deviceId];
          return {
            key: index.toString() + "_device" + deviceIndex.toString(),
            deviceName: deviceItem.name,
            model: deviceItem.model,
            os: deviceItem.os,
            type: deviceItem.type,
          };
        },
      );
      return {
        key: index.toString(),
        processName: item.business_process_name,
        informationSystems: item.information_systems.join(","),
        subItems: devices,
      };
    },
  );

  return (
    <CustomLayout>
      {contextHolder}
      <div style={{ padding: "20px" }}>
        {items.length > 0 ? (
          <EditableTable
            data={items}
            columns={columns}
            subColumns={subColumns}
          />
        ) : (
          <Empty></Empty>
        )}
      </div>
    </CustomLayout>
  );
}
