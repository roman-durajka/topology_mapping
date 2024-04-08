import { useEffect, useState } from "react";
import { Empty, message } from "antd";

import EditableTable from "./EditableTable";
import CustomLayout from "./CustomLayout";
import request from "./Requester";
import { messageLoading, messageSuccess } from "./message";
import { ColumnItem } from "./types";
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

  const groupedDevices: object[] = Object.keys(devices).map(
    (deviceId: string) => {
      let deviceData: { [index: string]: any } = devices[deviceId];
      deviceData["id"] = deviceId;
      deviceData["key"] = "device " + deviceId;

      let properties: object[] = [];
      Object.keys(deviceData).map((item: string) => {
        if (item in propertyMap) {
          let propertyItem: { [index: string]: any } = {
            key: `property ${item} ${deviceId}`,
            propertyName: propertyMap[item],
          };

          let propertyData: object[] = [];
          let propertyColumns: ColumnItem[] = [];
          Object.keys(devices[deviceId][item]).map((propertyId: string) => {
            const propertyValue: { [index: string]: any } =
              devices[deviceId][item][propertyId];

            //dynamically generate columns
            if (propertyColumns.length == 0) {
              const columnSize = 100 / propertyValue.length;
              Object.keys(propertyValue).map((propertyColumnKey: string) => {
                propertyColumns.push({
                  title: propertyColumnKey,
                  dataIndex: propertyColumnKey,
                  editable: true,
                  width: `${columnSize}%`,
                });
              });
            }

            propertyData.push({
              ...propertyValue,
              key: `property ${item} ${deviceId} ${propertyId}`,
            });
          });

          propertyItem["subComponent"] = (
            <EditableTable
              data={propertyData}
              onSave={() => {
                return;
              }}
              columns={propertyColumns}
              allowAdditions
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
              onSave={() => {
                return;
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
