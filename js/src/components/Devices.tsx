import { useEffect, useState } from "react";
import { Empty, message, notification } from "antd";

import EditableTable from "./EditableTable";
import CustomLayout from "./CustomLayout";
import request from "./Requester";
import { messageLoading, messageSuccess } from "./message";
import { ColumnItem, StringIndexedObject } from "./types";
import { TopologyConnector, addDeviceFormObject } from "../TopologyConnector";
import { addDeviceFormSubmit } from "../helpers/addDevice";
import Form from "./Form";
import Modal from "./Modal";

interface InterfaceDevices {
  connector: TopologyConnector;
}

const Devices: React.FC<InterfaceDevices> = ({ connector }) => {
  const [messageApi, contextHolder] = message.useMessage();
  const [devices, setDevices] = useState<{
    [index: string]: any;
  }>({});

  useEffect(() => {
    const responseData: Promise<Response> = request({
      url: "http://localhost:5000/devices-get",
      method: "GET",
    });
    messageLoading(messageApi, "Loading page...");
    responseData
      .then((response) => response.json())
      .then((data) => {
        setDevices(data.data);
      });
    messageApi.destroy();
    messageSuccess(messageApi, "Page loaded.");
  }, []);

  const columns: ColumnItem[] = [
    {
      title: "ID",
      dataIndex: "id",
      width: "10%",
      editable: false,
    },
    {
      title: "Name",
      dataIndex: "name",
      width: "80%",
      editable: true,
    },
  ];

  const subColumns: ColumnItem[] = [
    {
      title: "Properties",
      dataIndex: "propertyName",
      width: "100%",
      editable: false,
    },
  ];

  const propertyMap: { [index: string]: any } = {
    interfaces: "Interfaces",
    routing_table: "Routing Table",
    mac_table: "MAC Table",
    arp_table: "ARP Table",
    details: "Device details",
  };

  const groupedDevices: StringIndexedObject[] = Object.keys(devices).map(
    (deviceId: string) => {
      let deviceData: StringIndexedObject = devices[deviceId];
      deviceData["id"] = deviceId;
      deviceData["key"] = "device " + deviceId;

      let properties: object[] = [];
      Object.keys(deviceData).map((item: string) => {
        if (item in propertyMap) {
          let propertyItem: { [index: string]: any } = {
            key: `property ${item} ${deviceId}`,
            propertyName: propertyMap[item],
          };

          let propertyData: { [index: string]: any }[] = [];
          let propertyColumns: ColumnItem[] = [];
          Object.keys(devices[deviceId][item]).map((propertyId: string) => {
            const propertyValue: { [index: string]: any } =
              devices[deviceId][item][propertyId];

            //dynamically generate columns
            if (propertyColumns.length == 0) {
              const columnSize = 100 / propertyValue.length;
              const editable =
                "editable" in propertyValue ? propertyValue["editable"] : true;
              Object.keys(propertyValue).map((propertyColumnKey: string) => {
                propertyColumns.push({
                  title: propertyColumnKey,
                  dataIndex: propertyColumnKey,
                  editable: editable,
                  width: `${columnSize}%`,
                });
              });
            }

            propertyData.push({
              ...propertyValue,
              key: `property ${item} ${deviceId} ${propertyId}`,
              table: item,
              id: propertyId,
            });
          });

          propertyItem["subComponent"] = (
            <EditableTable
              data={propertyData}
              onSave={(
                newData: object,
                editExisting: (responseData: object) => void,
              ) => {
                //make request and return id
                //add returned id to item object in table, and also new key

                if ("id" in newData && Number(newData["id"]) < 0) {
                  delete newData["id"];
                }

                const responseData: Promise<Response> = request({
                  url: "http://localhost:5000/XXXXXX",
                  method: "POST",
                  postData: newData,
                });

                responseData
                  .then((response) => response.json())
                  .then((data) => {
                    if (data["code"] == 200) {
                      data["data"]["key"] =
                        `property ${item} ${deviceId} ${data["data"]["id"]}`;
                      editExisting(data["data"]);
                    } else {
                      notification.error({
                        message: "Error saving edited row",
                        description: data["error"],
                        placement: "top",
                        duration: 0,
                      });
                    }
                  });
              }}
              onDelete={(index: number, deleteRow: () => void) => {
                const postData = {
                  table: propertyData[index]["table"],
                  id: propertyData[index]["id"],
                };

                const responseData: Promise<Response> = request({
                  url: "http://localhost:5000/XXXXXX",
                  method: "POST",
                  postData: postData,
                });

                responseData
                  .then((response) => response.json())
                  .then((data) => {
                    if (data["code"] == 200) {
                      deleteRow();
                    } else {
                      notification.error({
                        message: "Error deleting row",
                        description: data["error"],
                        placement: "top",
                        duration: 0,
                      });
                    }
                  });
              }}
              columns={propertyColumns}
              onAdd={(addRow: (newRow: object) => void) => {
                let dataToAdd: object = {
                  table: item,
                  key: "newItem",
                };
                addRow(dataToAdd);
              }}
            />
          );
          properties.push(propertyItem);
        }
      });

      deviceData["subComponent"] = (
        <EditableTable
          data={properties}
          onSave={() => {
            return;
          }}
          columns={subColumns}
        />
      );

      return deviceData;
    },
  );

  const modals: React.ReactNode[] = [
    <Modal
      title="Add device"
      children={
        <Form
          formItems={addDeviceFormObject}
          onFinishFun={(data: { [key: string]: any }) =>
            addDeviceFormSubmit(data, connector, messageApi)
          }
        />
      }
    />,
  ];

  return (
    <CustomLayout modals={modals}>
      {contextHolder}
      <div style={{ padding: "20px" }}>
        {groupedDevices.length > 0 ? (
          <div style={{ marginBottom: "50px" }}>
            <EditableTable
              data={groupedDevices}
              onSave={(
                newData: StringIndexedObject,
                editExisting: (responseData: object) => void,
              ) => {
                const postData = {
                  id: newData["id"],
                  name: newData["name"],
                  table: "devices",
                };

                const responseData: Promise<Response> = request({
                  url: "http://localhost:5000/XXXXXX",
                  method: "POST",
                  postData: postData,
                });

                responseData
                  .then((response) => response.json())
                  .then((data) => {
                    if (data["code"] == 200) {
                      data["data"]["key"] = `device ${newData["id"]}`;
                      editExisting(data["data"]);
                    } else {
                      notification.error({
                        message: "Error saving edited row",
                        description: data["error"],
                        placement: "top",
                        duration: 0,
                      });
                    }
                  });
              }}
              onDelete={(index: number, deleteRow: () => void) => {
                const postData = {
                  table: "devices",
                  id: groupedDevices[index]["id"],
                };

                const responseData: Promise<Response> = request({
                  url: "http://localhost:5000/XXXXXX",
                  method: "POST",
                  postData: postData,
                });

                responseData
                  .then((response) => response.json())
                  .then((data) => {
                    if (data["code"] == 200) {
                      deleteRow();
                    } else {
                      notification.error({
                        message: "Error deleting row",
                        description: data["error"],
                        placement: "top",
                        duration: 0,
                      });
                    }
                  });
              }}
              columns={columns}
              title={<div style={{ textAlign: "center" }}>Devices</div>}
            />
          </div>
        ) : (
          <Empty></Empty>
        )}
      </div>
    </CustomLayout>
  );
};

export default Devices;
