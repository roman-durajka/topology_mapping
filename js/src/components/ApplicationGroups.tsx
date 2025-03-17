import { useEffect, useState } from "react";
import { message, Empty, Table } from "antd";

import CustomLayout from "./CustomLayout";
import { messageLoading, messageSuccess } from "./message";
import request from "./Requester";
import { ColumnItem, SubColumnGroup } from "./types";
import EditableTable from "./EditableTable";
import EditableText from "./EditableText";

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

function getMappedDevices(devices: object[]) {
  const mappedDevices = Object.keys(devices).map(
    (deviceId: any, deviceIndex: number) => {
      const device: { [index: string]: any } = devices[deviceId];

      return {
        key: deviceIndex.toString() + "_device" + deviceIndex.toString(),
        deviceName: device["name"],
        model: device["model"],
        os: device["os"],
        type: device["type"],
      };
    },
  );

  return mappedDevices;
}

function getMappedPaths(paths: object[]) {
  const mappedPaths = Object.keys(paths).map(
    (pathId: any, pathIndex: number) => {
      const pathItem: { [index: string]: any } = paths[pathId];
      const devices: object[] = getMappedDevices(pathItem["devices"]);

      return {
        key: pathIndex.toString(),
        pathId: pathId,
        pathName: pathItem.path_name,
        informationSystems: pathItem.information_systems.join(","),
        subComponent: (
          <Table
            columns={subColumns}
            dataSource={devices}
            pagination={false}
            bordered
          />
        ),
      };
    },
  );

  return mappedPaths;
}

function getMappedApplicationGroups(applicationGroups: {
  [index: string]: any;
}) {
  const mappedApplicationGroups = Object.keys(applicationGroups).map(
    (groupId: any) => {
      const groupItem: { [index: string]: any } = applicationGroups[groupId];
      const paths: object[] = getMappedPaths(groupItem["paths"]);
      return {
        applicationGroupName:
          applicationGroups[groupId]["application_group_name"],
        applicationGroupId: groupId,
        paths: paths,
      };
    },
  );

  return mappedApplicationGroups;
}

export default function ApplicationGroups() {
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

        messageApi.destroy();
        messageSuccess(messageApi, "Page loaded.");
      });
  }, []);

  const mappedApplicationGroups: object[] =
    getMappedApplicationGroups(applicationGroups);

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
        {mappedApplicationGroups.length > 0 ? (
          mappedApplicationGroups.map((group: { [index: string]: any }) => (
            <div style={{ marginBottom: "50px" }}>
              <EditableTable
                data={group["paths"]}
                onSave={onTableSave}
                columns={columns}
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
