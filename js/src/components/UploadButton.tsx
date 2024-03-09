import React from "react";
import { InboxOutlined } from "@ant-design/icons";
import type { UploadProps } from "antd";
import Dragger from "antd/es/upload/Dragger";

interface InterfaceUploadButton {
  props: UploadProps;
}

const UploadButton: React.FC<InterfaceUploadButton> = ({ props }) => {
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
