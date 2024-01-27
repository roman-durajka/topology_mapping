import { useEffect, useState } from "react";
import { message, Empty, DescriptionsProps, Space, Divider } from "antd";

import CustomLayout from "../CustomLayout";
import { messageLoading, messageSuccess } from "../message";
import request from "./Requester";
import CustomDescription from "./Description";
import {
  ColumnItem,
  ColumnGroup,
  SubColumnGroup,
  SubColumnItem,
} from "./types";
import EditableTable from "./EditableTable";
import EditableText from "./EditableText";

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
      const groupItem: object = applicationGroups[groupId];
      const paths: object[] = Object.keys(groupItem["paths"]).map(
        (pathId: string, index: number) => {
          const pathItem: object = applicationGroups[groupId]["paths"][pathId];
          const devices: object[] = Object.keys(pathItem["devices"]).map(
            (deviceId: string, deviceIndex: number) => {
              const deviceItem: object = pathItem["devices"][deviceId];
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
            pathId: pathId,
            pathName: pathItem.path_name,
            informationSystems: pathItem.information_systems.join(","),
            subItems: devices,
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

  const onGroupNameChange = (newName: string, groupId: number) => {
    let formData: object = {
      applicationGroupId: groupId,
      applicationGroupName: newName,
    };

    request({
      url: "http://localhost:5000/update-application-groups",
      method: "POST",
      postData: formData,
    });

    messageSuccess(messageApi, "Bussiness process name successfully changed.");
  };

  const onTableSave = (newData: object) => {
    request({
      url: "http://localhost:5000/update-application-groups",
      method: "POST",
      postData: newData,
    });

    messageSuccess(messageApi, "Data successfully changed.");
  };

  return (
    <CustomLayout>
      {contextHolder}
      <div style={{ padding: "20px" }}>
        {groups.length > 0 ? (
          groups.map((group: object) => (
            <div style={{ marginBottom: "50px" }}>
              <EditableTable
                data={group["paths"]}
                onSave={onTableSave}
                columns={columns}
                subColumns={subColumns}
                title={
                  <div style={{ textAlign: "center" }}>
                    <EditableText
                      text={group["applicationGroupName"]}
                      onChange={(newText: string) => {
                        onGroupNameChange(newText, group["applicationGroupId"]);
                      }}
                    ></EditableText>
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
