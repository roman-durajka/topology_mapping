import {useEffect, useState, ReactNode} from "react";
import { message, Empty, Table } from "antd";

import CustomLayout from "./CustomLayout";
import { messageLoading, messageSuccess } from "./message";
import request from "./Requester";
import { ColumnItem, SubColumnGroup, StringIndexedObject } from "./types";
import EditableTable from "./EditableTable";
import EditableText from "./EditableText";
import RiskManagementTable from "./RiskManagementTable.tsx";

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

function expandedRowRenderFun(props: object) {
  if (props && "subComponent" in props) {
    return props["subComponent"] as ReactNode;
  }
}

//function getEditableCell(value: any, save: () => void) {
//  return <EditableText text={value.toString()} onChange={save}></EditableText>;
//}

export default function RiskManagement() {
  const [messageApi, contextHolder] = message.useMessage();

  //custom functions
  const getMappedDevices = (devices: StringIndexedObject) => {
    const mappedDevices = Object.keys(devices).map(
      (deviceId: string, deviceIndex: number) => {
        const device: StringIndexedObject = devices[deviceId];

        return {
          key: deviceIndex.toString() + "_device" + deviceId.toString(),
          deviceName: device["name"],
          model: device["model"],
          os: device["os"],
          type: device["type"],
          subComponent: (
            <RiskManagementTable deviceData={device} deviceId={deviceId}></RiskManagementTable>
          ),
        };
      },
    );

    return mappedDevices;
  };

  const getMappedPaths = (paths: StringIndexedObject) => {
    const mappedPaths = Object.keys(paths).map(
      (pathId: string, pathIndex: number) => {
        const pathItem: StringIndexedObject = paths[pathId];
        const devices: object[] = getMappedDevices(pathItem["devices"]);

        return {
          key: pathIndex.toString(),
          pathId: pathId,
          pathName: pathItem["path_name"],
          informationSystems: pathItem["information_systems"].join(","),
          subComponent: (
            <Table
              columns={subColumns}
              dataSource={devices}
              pagination={false}
              expandedRowRender={expandedRowRenderFun}
              bordered
            />
          ),
        };
      },
    );

    return mappedPaths;
  };

  const getMappedApplicationGroups = (
    applicationGroups: StringIndexedObject,
  ) => {
    const mappedApplicationGroups = Object.keys(applicationGroups).map(
      (groupId: any) => {
        const groupItem: StringIndexedObject = applicationGroups[groupId];
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
  };

  //end of custom functions

  const [pageData, setPageData] = useState<StringIndexedObject>({});

  useEffect(() => {
    const responseData: Promise<Response> = request({
      url: "http://localhost:5000/risk-management",
      method: "GET",
    });
    messageLoading(messageApi, "Loading page...");
    responseData
      .then((response) => response.json())
      .then((data) => {
        const mappedPageData = getMappedApplicationGroups(data.data);
        setPageData(mappedPageData);

        messageApi.destroy();
        messageSuccess(messageApi, "Page loaded.");
      });
  }, []);

  const onGroupNameChange = (newName: string, groupId: number) => {
    const formData: object = {
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
        {pageData.length > 0 ? (
          pageData.map((group: StringIndexedObject) => (
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
