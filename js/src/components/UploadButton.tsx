import React from "react";
import { InboxOutlined } from "@ant-design/icons";
import type { UploadProps } from "antd";
import { message } from "antd";
import Dragger from "antd/es/upload/Dragger";
import request from "./Requester";

const props: UploadProps = {
  name: "file",
  action: "",
  headers: {
    authorization: "authorization-text",
    "content-type": "application/json",
  },
  accept: ".json",
  customRequest({ onSuccess, onError, file, action }) {
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
        url: action as string,
        method: "POST",
        postData: formData,
      });

      responseData
        .then((response) => response.json())
        .then((data) => {
          // CHECK FOR ERRORS ----------------------------------------------------------------------------------------------------------
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
      console.log(info.file, info.fileList);
    }
    if (info.file.status === "done") {
      message.success(`${info.file.name} file uploaded successfully.`);
    } else if (info.file.status === "error") {
      message.error(`${info.file.name} file upload failed.`);
    }
  },
  onDrop(e) {
    console.log("Dropped files", e.dataTransfer.files);
  },
};

interface InterfaceUploadButton {
  url: string;
}

const UploadButton: React.FC<InterfaceUploadButton> = ({ url }) => {
  props.action = url;

  return (
    <Dragger {...props}>
      <p className="ant-upload-drag-icon">
        <InboxOutlined />
      </p>
      <p className="ant-upload-text">
        Click or drag file to this area to upload files
      </p>
      <p className="ant-upload-hint">
        Here you should upload scheme filled with data you want to insert into
        database.
      </p>
    </Dragger>
  );
};

export default UploadButton;
