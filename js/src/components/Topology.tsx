import { useEffect, useRef, useState } from "react";
import { Button, Flex, message, notification } from "antd";

import request from "./Requester";
import { messageSuccess, messageLoading } from "./message";
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
import { generateJsonFile, SchemeUploadButtonProps } from "./Scheme";
import { addDeviceFormSubmit } from "../helpers/addDevice";

interface InterfaceTopology {
  connector: TopologyConnector;
}

const Topology: React.FC<InterfaceTopology> = ({ connector }) => {
  const [messageApi, contextHolder] = message.useMessage();
  const topologyContainer = useRef(null);
  const [pathTableData, setPathTableData] = useState<PathTableItem[]>([]);

  //load once on startup
  useEffect(() => {
    if (topologyContainer.current) {
      connector.attach(topologyContainer.current);
      const responseData: Promise<Response> = request({
        url: "http://localhost:5000/topology",
        method: "GET",
      });
      messageLoading(messageApi, "Loading topology...");
      responseData
        .then((response) => response.json())
        .then((data) => connector.loadTopology(data))
        .then(() => {
          const pathResponseData: Promise<Response> = request({
            url: "http://localhost:5000/load-paths",
            method: "GET",
          });
          return pathResponseData;
        })
        .then((response) => response.json())
        .then((data) => {
          connector.loadPaths(data.data);
          const pathTableData: PathTableItem[] = connector.formatPathTableData(
            data.data,
          );
          setPathTableData(pathTableData);
          messageApi.destroy();
          messageSuccess(messageApi, "Topology loaded.");
        });
    }
  }, []);

  const addPathFormSubmit = (props: object) => {
    const formData = {
      ...props,
      startingIndex: connector.getPathStartingIndex(),
    };
    const responseData: Promise<Response> = request({
      url: "http://localhost:5000/add-path",
      method: "POST",
      postData: formData,
    });

    responseData
      .then((response) => response.json())
      .then((data) => {
        if (data.code != 200) {
          notification.error({
            message: "Could not add path to topology",
            description: data.error,
            placement: "top",
            duration: 0,
          });
          return;
        }
        //add paths to topology
        connector.addPath(data.data);
        //add paths to path table
        const newPathTableData: PathTableItem[] = connector.formatPathTableData(
          [{ ...data.data, formData }],
        );
        setPathTableData([...pathTableData, ...newPathTableData]);
        //make alert
        messageSuccess(messageApi, "Path was successfully added.");
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
          onFinishFun={(data: { [key: string]: any }) =>
            addDeviceFormSubmit(data, connector, messageApi)
          }
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
              href={generateJsonFile(connector)}
              download
            >
              Download blank scheme
            </Button>
            <UploadButton props={SchemeUploadButtonProps} />
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
};

export default Topology;
