import { useEffect, useState, ReactNode } from "react";
import { message, Empty, Table } from "antd";

import CustomLayout from "./CustomLayout";
import { messageLoading, messageSuccess } from "./message";
import request from "./Requester";
import { ColumnItem, SubColumnGroup, StringIndexedObject } from "./types";
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

const riskManagementColumns: object[] = [
  {
    title: "Asset",
    dataIndex: "assetName",
    width: "10%",
  },
  {
    title: "Impact",
    children: [
      {
        title: "C",
        dataIndex: "impactC",
        width: "2%",
      },
      {
        title: "I",
        dataIndex: "impactI",
        width: "2%",
      },
      {
        title: "A",
        dataIndex: "impactA",
        width: "2%",
      },
    ],
  },
  {
    title: "Threat",
    dataIndex: "threatName",
  },
  {
    title: "Vulnerability",
    dataIndex: "vulnerabilityName",
  },
  {
    title: "Impact",
    children: [
      {
        title: "C",
        dataIndex: "currentRiskC",
        width: "2%",
      },
      {
        title: "I",
        dataIndex: "currentRiskI",
        width: "2%",
      },
      {
        title: "A",
        dataIndex: "currentRiskA",
        width: "2%",
      },
    ],
  },
];

function expandedRowRenderFun(props: object) {
  if (props && "subComponent" in props) {
    return props["subComponent"] as ReactNode;
  }
}

function getRiskManagementData(
  riskManagementData: StringIndexedObject,
  deviceId: any,
) {
  const mappedRiskManagement: object[] = [];

  //map assets
  Object.keys(riskManagementData).map((assetUUID: string) => {
    const assetData: StringIndexedObject = riskManagementData[assetUUID];
    const asset: string = assetData["asset_name"];

    //map risks
    const risks: StringIndexedObject = assetData["risks"];
    Object.keys(risks).map((riskUUID: string) => {
      const risk: StringIndexedObject = risks[riskUUID];

      const threat: any = Object.values(risk["threat"])[0];
      const vulnerability: any = Object.values(risk["vulnerability"])[0];

      mappedRiskManagement.push({
        key: "risk_management_device-" + deviceId.toString(),
        assetName: asset,
        threatName: threat,
        vulnerabilityName: vulnerability,
      });
    });
  });

  return mappedRiskManagement;
}

function getMappedDevices(devices: StringIndexedObject) {
  const mappedDevices = Object.keys(devices).map(
    (deviceId: string, deviceIndex: number) => {
      const device: StringIndexedObject = devices[deviceId];

      const riskManagementData: object[] = getRiskManagementData(
        device["asset"],
        deviceId,
      );

      return {
        key: deviceIndex.toString() + "_device" + deviceId.toString(),
        deviceName: device["name"],
        model: device["model"],
        os: device["os"],
        type: device["type"],
        subComponent: (
          <Table
            columns={riskManagementColumns}
            dataSource={riskManagementData}
            bordered
          />
        ),
      };
    },
  );

  return mappedDevices;
}

function getMappedPaths(paths: StringIndexedObject) {
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
}

function getMappedApplicationGroups(applicationGroups: {
  [index: string]: any;
}) {
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
}

export default function RiskManagement() {
  const [messageApi, contextHolder] = message.useMessage();
  const [riskManagementData, setRiskManagementData] = useState<{
    [index: string]: any;
  }>({});

  useEffect(() => {
    const responseData: Promise<Response> = request({
      url: "http://localhost:5000/risk-management",
      method: "GET",
    });
    messageLoading(messageApi, "Loading page...");
    responseData
      .then((response) => response.json())
      .then((data) => {
        setRiskManagementData(data.data);

        messageApi.destroy();
        messageSuccess(messageApi, "Page loaded.");
      });
  }, []);

  const mappedRiskManagementData: object[] =
    getMappedApplicationGroups(riskManagementData);

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
        {mappedRiskManagementData.length > 0 ? (
          mappedRiskManagementData.map((group: StringIndexedObject) => (
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
