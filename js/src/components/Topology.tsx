import { useEffect, useRef, useState } from "react";
import { Button, Flex, message } from "antd";

import request from "./Requester";
import { messageError, messageSuccess, messageLoading } from "./message";
import {
  TopologyConnector,
  addPathFormObject,
  addDeviceFormObject,
} from "../TopologyConnector";
import CustomLayout from "./CustomLayout";

import Modal from "./Modal";
import Form from "./Form";
import PathTable from "./PathTable";
import { PathTableItem } from "./types";
import { DownloadOutlined } from "@ant-design/icons";
import UploadButton from "./UploadButton";

function Topology() {
  const [messageApi, contextHolder] = message.useMessage();
  const topologyContainer = useRef(null);
  const [pathTableData, setPathTableData] = useState<PathTableItem[]>([]);
  const connector = useRef(new TopologyConnector());

  //load once on startup
  useEffect(() => {
    if (topologyContainer.current) {
      connector.current.init(topologyContainer.current);
      const responseData: Promise<Response> = request({
        url: "http://localhost:5000/topology",
        method: "GET",
      });
      messageLoading(messageApi, "Loading topology...");
      responseData
        .then((response) => response.json())
        .then((data) => connector.current.loadTopology(data))
        .then(() => {
          const pathResponseData: Promise<Response> = request({
            url: "http://localhost:5000/load-paths",
            method: "GET",
          });
          return pathResponseData;
        })
        .then((response) => response.json())
        .then((data) => {
          connector.current.loadPaths(data.data);
          const pathTableData: PathTableItem[] =
            connector.current.formatPathTableData(data.data);
          setPathTableData(pathTableData);
          messageApi.destroy();
          messageSuccess(messageApi, "Topology loaded.");
        });
    }
  }, []);

  const addPathFormSubmit = (props: object) => {
    const formData = {
      ...props,
      startingIndex: connector.current.getPathStartingIndex(),
    };
    const responseData: Promise<Response> = request({
      url: "http://localhost:5000/add-path",
      method: "POST",
      postData: formData,
    });

    responseData
      .then((response) => response.json())
      .then((data) => {
        //add paths to topology
        connector.current.addPath(data.data);
        //add paths to path table
        const newPathTableData: PathTableItem[] =
          connector.current.formatPathTableData([{ ...data.data, formData }]);
        setPathTableData([...pathTableData, ...newPathTableData]);
        //make alert
        messageSuccess(messageApi, "Path was successfully added.");
      });
  };

  const addDeviceFormSubmit = (props: { [key: string]: any }) => {
    const formData = {
      ...props,
      icon: props.type,
      "asset-value": 0,
      "asset-values": [0],
      id: connector.current.getNodeStartingIndex(),
    };
    const responseData: Promise<Response> = request({
      url: "http://localhost:5000/add-device",
      method: "POST",
      postData: formData,
    });

    responseData
      .then((response) => response.json())
      .then((data) => {
        //add device to topology
        connector.current.addDevice(formData);
        //make alert
        if (data.code === 200) {
          messageSuccess(messageApi, "Device was successfully added.");
        } else {
          messageError(messageApi, "Could not add device: ${data.error}");
        }
        console.log(formData);
      });
  };

  const modals: React.ReactNode[] = [
    <Modal
      title="Add path"
      children={
        <Form formItems={addPathFormObject} onFinishFun={addPathFormSubmit} />
      }
    />,
    <Modal
      title="Add device"
      children={
        <Form
          formItems={addDeviceFormObject}
          onFinishFun={addDeviceFormSubmit}
        />
      }
    />,
    <Modal
      title="Import scheme"
      children={
        <>
          <Flex vertical gap="middle" justify="center" align="center">
            <Button
              icon={<DownloadOutlined />}
              size="large"
              href="import-scheme.json"
              download
            >
              Download blank scheme
            </Button>
            <UploadButton />
          </Flex>
        </>
      }
    />,
  ];

  return (
    <CustomLayout modals={modals}>
      {contextHolder}
      <div className="TopologyContent" ref={topologyContainer}></div>
      <PathTable items={pathTableData} setPathTableData={setPathTableData} />
    </CustomLayout>
  );
}

export default Topology;
