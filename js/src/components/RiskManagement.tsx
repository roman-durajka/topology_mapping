import { useEffect, useState } from "react";
import { message, Empty, Table } from "antd";

import CustomLayout from "./CustomLayout";
import { messageLoading, messageSuccess } from "./message";
import request from "./Requester";
import { ColumnItem, SubColumnGroup } from "./types";
import EditableTable from "./EditableTable";

export default function RiskManagement() {
  const [messageApi, contextHolder] = message.useMessage();
  const [applicationGroups, setApplicationGroups] = useState<{
    [index: string]: any;
  }>({});

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
      title: "path name",
      dataIndex: "pathName",
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
  const groups: object[] = Object.keys(applicationGroups).map(
    (groupId: string) => {
      const groupItem: { [index: string]: any } = applicationGroups[groupId];
      const paths: object[] = Object.keys(groupItem["paths"]).map(
        (pathId: string, index: number) => {
          const pathItem: { [index: string]: any } =
            applicationGroups[groupId]["paths"][pathId];
          const devices: object[] = Object.keys(pathItem["devices"]).map(
            (deviceId: string, deviceIndex: number) => {
              const deviceItem: { [index: string]: any } =
                pathItem["devices"][deviceId];
              return {
                key: index.toString() + "_device" + deviceIndex.toString(),
                deviceName: deviceItem["name"],
                model: deviceItem["model"],
                os: deviceItem["os"],
                type: deviceItem["type"],
              };
            },
          );
          return {
            key: index.toString(),
            pathId: pathId,
            pathName: pathItem.path_name,
            informationSystems: pathItem.information_systems.join(","),
            subComponent: (
              <Table
                columns={subColumns}
                dataSource={devices}
                pagination={false}
              />
            ),
          };
        },
      );
      return {
        applicationGroupName:
          applicationGroups[groupId]["application_group_name"],
        applicationGroupId: groupId,
        paths: paths,
      };
    },
  );

  return (
    <CustomLayout>
      {contextHolder}
      <div style={{ padding: "20px" }}>
        {groups.length > 0 ? (
          groups.map((group: { [index: string]: any }) => (
            <div style={{ marginBottom: "50px" }}>
              <EditableTable
                data={group["paths"]}
                onSave={() => {}}
                columns={columns}
                title={
                  <div style={{ textAlign: "center" }}>
                    group["applicationGroupName"]
                  </div>
                }
              />
            </div>
          ))
        ) : (
          <Empty></Empty>
        )}
      </div>
    </CustomLayout>
  );
}
