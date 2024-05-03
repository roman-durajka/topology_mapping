import { TopologyConnector } from "../TopologyConnector";
import originalJson from "../config/import-scheme.json";
import type { UploadProps } from "antd";
import { Space, message, notification, Button, Flex } from "antd";
import request from "./Requester";
import { DownloadOutlined } from "@ant-design/icons";
import UploadButton from "./UploadButton";

const notificationButton = (onClick: () => void) => {
  return (
    <>
      <Button type="primary" danger size="large" onClick={() => onClick()}>
        Confirm
      </Button>
    </>
  );
};

const SchemeUploadButtonProps: UploadProps = {
  name: "file",
  headers: {
    authorization: "authorization-text",
    "content-type": "application/json",
  },
  accept: ".json",
  customRequest({ onSuccess, onError, file }) {
    const fileReader = new FileReader();
    fileReader.onload = (e) => {
      let formData: object = {};
      try {
        if (e.target) formData = JSON.parse(e.target.result as string);
      } catch (error) {
        if (onError) onError(error as ProgressEvent<EventTarget>, file);
        return;
      }

      const responseData: Promise<Response> = request({
        url: "http://localhost:5000/scheme-update",
        method: "POST",
        postData: formData,
      });

      responseData
        .then((response) => response.json())
        .then((data) => {
          if (data.code != 200) {
            throw { code: data.code, message: data.error, fileData: formData };
          }
          if (onSuccess) onSuccess(data);
        })
        .catch((error) => {
          if (onError) onError(error, file);
        });
    };

    fileReader.readAsText(file as Blob);
  },
  onChange(info) {
    if (info.file.status !== "uploading") {
    }
    if (info.file.status === "done") {
      message.success(`${info.file.name} file uploaded successfully.`);
    } else if (info.file.status === "error") {
      if (info.file.error.code == 409) {
        notification.warning({
          message: "Could not process scheme",
          description: (
            <>
              <Space direction="vertical" size="large">
                {info.file.error.message}
                {"Do you want to replace the existing data?"}
                {notificationButton(() => {
                  notification.destroy();
                  const responseData: Promise<Response> = request({
                    url: "http://localhost:5000/scheme-replace",
                    method: "POST",
                    postData: info.file.error.fileData,
                  });

                  responseData
                    .then((response) => response.json())
                    .then((data) => {
                      if (data.code != 200) {
                        message.error(
                          `ERROR - Check console for more details.`,
                        );
                        console.log(data.error);
                      } else {
                        message.success(`Data replaced successfully.`);
                      }
                    });
                })}
              </Space>
            </>
          ),
          placement: "top",
          duration: 0,
        });
      } else {
        notification.error({
          message: "Error procesing uploaded file",
          description: info.file.error.message,
          placement: "top",
          duration: 0,
        });
      }
    }
  },
  onDrop(e) {
    console.log("Dropped files", e.dataTransfer.files);
  },
};

interface InterfaceSchemeWindow {
  connector: TopologyConnector;
}

const SchemeWindow: React.FC<InterfaceSchemeWindow> = ({ connector }) => {
  const generateJsonFile: () => string | undefined = () => {
    if (connector.topology) {
      let resultingJson: string =
        "########## START WITH THESE VALUES WHEN ADDING NEW NODES AND INTERFACES, THEN DELETE THIS COMMMENT\n";
      resultingJson += `device_id: ${connector.getNodeStartingIndex()}\n`;
      resultingJson += `port_id: ${connector.getIfStartingIndex()}\n`;
      resultingJson += "##########\n\n";

      resultingJson += JSON.stringify(originalJson);

      const blob = new Blob([resultingJson], {
        type: "application/json",
      });
      return URL.createObjectURL(blob);
    }
  };

  return (
    <>
      <Flex vertical gap="middle" justify="center" align="center">
        <Button
          icon={<DownloadOutlined />}
          size="large"
          href={generateJsonFile()}
          download
        >
          Download example scheme
        </Button>
        <UploadButton props={SchemeUploadButtonProps} />
      </Flex>
    </>
  );
};

export { SchemeWindow };
