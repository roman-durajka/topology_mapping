import { useEffect, useState, ReactNode } from "react";
import { message, Empty, Table, Select } from "antd";

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
    title: "Asset category",
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
    children: [
      {
        title: "Label",
        dataIndex: "threatName",
      },
      {
        title: "Prob.",
        dataIndex: "threatProbability",
      },
    ],
  },
  {
    title: "Vulnerability",
    children: [
      {
        title: "Label",
        dataIndex: "vulnerabilityName",
      },
      {
        title: "Qualif.",
        dataIndex: "vulnerabilityQualification",
      },
    ],
  },
  {
    title: "Current risk",
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
  {
    title: "Treatment",
    children: [
      {
        title: "Label",
        dataIndex: "treatmentLabel",
      },
      {
        title: "Effect.",
        dataIndex: "treatmentEffectiveness",
      },
    ],
  },
  {
    title: "Risk after treatment",
    children: [
      {
        title: "C",
        dataIndex: "riskAfterTreatmentC",
        width: "2%",
      },
      {
        title: "I",
        dataIndex: "riskAfterTreatmentI",
        width: "2%",
      },
      {
        title: "A",
        dataIndex: "riskAfterTreatmentA",
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

function getSelectableCell(
  defaultValue: any,
  values: any[],
  save: (value: StringIndexedObject) => void,
) {
  return (
    <Select
      onChange={save}
      defaultValue={defaultValue}
      options={values.map((selectedValue) => ({
        value: selectedValue,
        label: selectedValue,
      }))}
    ></Select>
  );
}

//function getEditableCell(value: any, save: () => void) {
//  return <EditableText text={value.toString()} onChange={save}></EditableText>;
//}

export default function RiskManagement() {
  const [messageApi, contextHolder] = message.useMessage();

  //custom functions

  const [treatmentEffectivenessVal, setTreatmentEffectivenessVal] =
    useState<number>(1);

  const getRiskManagementData = (
    deviceData: StringIndexedObject,
    deviceId: any,
  ) => {
    const mappedRiskManagement: object[] = [];
    const riskManagementData: StringIndexedObject = deviceData["asset"];

    //map assets
    Object.keys(riskManagementData).map((assetUUID: string) => {
      const assetData: StringIndexedObject = riskManagementData[assetUUID];
      const asset: string = assetData["asset_name"];

      //map risks
      const risks: StringIndexedObject = assetData["risks"];
      Object.keys(risks).map((riskUUID: string) => {
        const risk: StringIndexedObject = risks[riskUUID];

        const threatObj: any = Object.values(risk["threat"])[0];
        const vulnerabilityObj: any = Object.values(risk["vulnerability"])[0];

        const threat: any = threatObj["name"];
        const vulnerability: any = vulnerabilityObj["name"];

        const threatProb: any = threatObj["probability"];
        const vulnerabilityQual: any = vulnerabilityObj["qualification"];

        const currentRiskCVal: number =
            risk["c"] * threatProb * vulnerabilityQual;
        const currentRiskIVal: number =
            risk["i"] * threatProb * vulnerabilityQual;
        const currentRiskAVal: number =
            risk["a"] * threatProb * vulnerabilityQual;

        const treatments: any = Object.keys(risk["measures"]).map(
          (measureUUID: string) => {
            return risk["measures"][measureUUID]["name"];
          },
        );

        mappedRiskManagement.push({
          key: "risk_management_device-" + deviceId.toString(),
          assetName: asset,
          threatName: threat,
          vulnerabilityName: vulnerability,
          impactC: getSelectableCell(
              risk["c"],
            [1, 2, 3, 4, 5],
            (newValue: StringIndexedObject) => {
              request({
                url: "http://localhost:5000/risk-management-update",
                method: "POST",
                postData: {"uuid": `${deviceId}-${riskUUID}`, "c": newValue},
              });
            },
          ),
          impactI: getSelectableCell(
            risk["i"],
            [1, 2, 3, 4, 5],
              (newValue: StringIndexedObject) => {
                request({
                  url: "http://localhost:5000/risk-management-update",
                  method: "POST",
                  postData: {"uuid": `${deviceId}-${riskUUID}`, "i": newValue},
                });
              },
          ),
          impactA: getSelectableCell(
              risk["a"],
            [1, 2, 3, 4, 5],
              (newValue: StringIndexedObject) => {
                request({
                  url: "http://localhost:5000/risk-management-update",
                  method: "POST",
                  postData: {"uuid": `${deviceId}-${riskUUID}`, "a": newValue},
                });
              },
          ),
          threatProbability: getSelectableCell(
            threatProb,
            [1, 2, 3, 4, 5],
            () => {},
          ),
          vulnerabilityQualification: getSelectableCell(
            vulnerabilityQual,
            [1, 2, 3, 4, 5],
            () => {},
          ),
          currentRiskC: currentRiskCVal,
          currentRiskI: currentRiskIVal,
          currentRiskA: currentRiskAVal,
          treatmentLabel: getSelectableCell("", treatments, (value) => {
            Object.keys(risk["measures"]).map((measureUUID: string) => {
              if (risk["measures"][measureUUID]["name"] == value["label"]) {
                //risk["measures"][measureUUID]["effectiveness"],
                setTreatmentEffectivenessVal(5);
              }
              setTreatmentEffectivenessVal(5);
              console.log(treatmentEffectivenessVal);
            });
          }),
          treatmentEffectiveness: treatmentEffectivenessVal,
        });
      });
    });

    return mappedRiskManagement;
  };

  const getMappedDevices = (devices: StringIndexedObject) => {
    const mappedDevices = Object.keys(devices).map(
      (deviceId: string, deviceIndex: number) => {
        const device: StringIndexedObject = devices[deviceId];

        const riskManagementData: object[] = getRiskManagementData(
          device,
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

  //load page

  const [pageData, setPageData] = useState<StringIndexedObject>({});
  const [requestedData, setRequestedData] = useState<StringIndexedObject>({});

  useEffect(() => {
    const responseData: Promise<Response> = request({
      url: "http://localhost:5000/risk-management",
      method: "GET",
    });
    messageLoading(messageApi, "Loading page...");
    responseData
      .then((response) => response.json())
      .then((data) => {
        setRequestedData(data.data);
        const mappedPageData = getMappedApplicationGroups(data.data);
        setPageData(mappedPageData);

        messageApi.destroy();
        messageSuccess(messageApi, "Page loaded.");
      });
  }, []);

  useEffect(() => {
    const mappedPageData = getMappedApplicationGroups(requestedData);
    setPageData(mappedPageData);
  }, [treatmentEffectivenessVal]);

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
