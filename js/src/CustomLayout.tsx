import React from "react";
import { Link, useLocation } from "react-router-dom";
import { Breadcrumb, Layout, Menu, theme } from "antd";
import { ApartmentOutlined, RightOutlined } from "@ant-design/icons";

import CustomFunction from "./components/types";

const { Header, Content, Footer } = Layout;

interface InterfaceLayout {
  children: React.ReactNode;
  customFunctions?: CustomFunction[];
}

const CustomLayout: React.FC<InterfaceLayout> = ({
  children,
  customFunctions,
}) => {
  const {
    token: { colorBgContainer },
  } = theme.useToken();

  return (
    <Layout className="layout">
      <Header style={{ display: "flex", alignItems: "center" }}>
        <div className="demo-logo" />
        <Menu theme="dark" mode="horizontal" disabledOverflow={true}>
          <Menu.Item key="1" icon={<ApartmentOutlined />}>
            <Link to="/">Topology</Link>
          </Menu.Item>
          <Menu.Item key="2">
            <Link to="/asd">Elsewhere</Link>
          </Menu.Item>
          <RightOutlined />
          {customFunctions?.map((value) => (
            <Menu.Item key={value.name} onClick={value.fun}>
              {value.name}
            </Menu.Item>
          ))}
        </Menu>
      </Header>
      <Content style={{ padding: "0 50px" }}>
        <Breadcrumb style={{ margin: "16px 0" }}>
          <Breadcrumb.Item>Location: {useLocation().pathname}</Breadcrumb.Item>
        </Breadcrumb>
        <div
          className="site-layout-content"
          style={{ background: colorBgContainer }}
        >
          {children}
        </div>
      </Content>
      <Footer style={{ textAlign: "center" }}>
        Ant Design ©2023 Created by Ant UED
      </Footer>
    </Layout>
  );
};

export default CustomLayout;
