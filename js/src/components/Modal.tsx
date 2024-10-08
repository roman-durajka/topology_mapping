import React, { useState } from "react";
import { Button, Divider, Modal } from "antd";

interface InterfaceModal {
  children: React.ReactNode;
  title: string;
}

const CustomModal: React.FC<InterfaceModal> = ({ title, children }) => {
  const [open, setOpen] = useState(false);
  const [confirmLoading, setConfirmLoading] = useState(false);

  const showModal = () => {
    setOpen(true);
  };

  const handleOk = () => {
    setConfirmLoading(true);
    setTimeout(() => {
      setOpen(false);
      setConfirmLoading(false);
    }, 2000);
  };

  const handleCancel = () => {
    setOpen(false);
  };

  return (
    <>
      <Button type="primary" onClick={showModal}>
        {title}
      </Button>
      <Modal
        title={title}
        open={open}
        onOk={handleOk}
        confirmLoading={confirmLoading}
        onCancel={handleCancel}
        footer={null}
      >
        <Divider />
        {children}
      </Modal>
    </>
  );
};

export default CustomModal;
