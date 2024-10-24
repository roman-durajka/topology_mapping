import React, {useEffect, useState} from "react";
import {Button, Form, Input, Select} from "antd";

import { FormItem } from "./types";
import {useUnsavedChangesGlobal, useUnsavedChangesRouter} from "./unsavedChanges.tsx";

const onFinishFailed = (errorInfo: any) => {
  console.log("Failed:", errorInfo);
};

interface InterfaceForm {
  formItems: FormItem[];
  onFinishFun: (props: object) => void;
}

const CustomForm: React.FC<InterfaceForm> = ({ formItems, onFinishFun }) => {
  const [form] = Form.useForm();
  const [formValues, setFormValues] = useState({});
  const [isDirty, setIsDirty] = useState(false);

  const handleFormChange = (_: object , allValues: object) => {
    setFormValues(allValues);
  }

  useEffect(() => {
    const isFilled: boolean = Object.values(formValues).some(
        (value) => typeof value === 'string' && value.trim().length > 0
    );
    setIsDirty(isFilled);
    console.log(isFilled);
  }, [formValues]);

  const onFormFinish = (props: object) => {
    onFinishFun(props);
    form.resetFields();
  };

  useUnsavedChangesGlobal(isDirty);
  useUnsavedChangesRouter(isDirty);

  return (
    <Form
      form={form}
      name="basic"
      labelCol={{ span: 8 }}
      wrapperCol={{ span: 16 }}
      style={{ maxWidth: 600 }}
      initialValues={{ remember: false }}
      onFinish={onFormFinish}
      onFinishFailed={onFinishFailed}
      autoComplete="off"
      onValuesChange={handleFormChange}
    >
      {formItems.map((item: FormItem, index: number) => (
        <Form.Item
          key={index}
          label={item.label}
          name={item.propertyName}
          rules={[{ required: true, message: "Please fill in this field!" }]}
        >
          {item?.selectOptions ? (
            <Select>
              {item.selectOptions.map((value: string) => (
                <Select.Option value={value}>{value}</Select.Option>
              ))}
            </Select>
          ) : (
            <Input />
          )}
        </Form.Item>
      ))}
      <Form.Item wrapperCol={{ offset: 8, span: 16 }}>
        <Button type="primary" htmlType="submit">
          Submit
        </Button>
      </Form.Item>
    </Form>
  );
};

export default CustomForm;
