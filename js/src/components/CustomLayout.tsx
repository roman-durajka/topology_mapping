import React from "react";
import { Link, useLocation } from "react-router-dom";
import { Breadcrumb, Layout, Menu, theme, Space } from "antd";
import { ApartmentOutlined, RightOutlined } from "@ant-design/icons";

const { Header, Content, Footer } = Layout;

interface InterfaceLayout {
  children: React.ReactNode;
  modals?: React.ReactNode[];
}

const CustomLayout: React.FC<InterfaceLayout> = ({ children, modals }) => {
  const {
    token: { colorBgContainer },
  } = theme.useToken();

  return (
    <Layout className="layout" style={{ minHeight: "100vh" }}>
      <Header
        style={{
          display: "flex",
          alignItems: "center",
          width: "99vw",
          position: "sticky",
          top: 0,
          zIndex: 1,
        }}
      >
        <div className="demo-logo" />
        <Menu theme="dark" mode="horizontal" disabledOverflow={true}>
          <Space>
            <Menu.Item key="1" icon={<ApartmentOutlined />}>
              <Link to="/">Topology</Link>
            </Menu.Item>
            <Menu.Item key="2">
              <Link to="/business-process">Business Process</Link>
            </Menu.Item>
            <Menu.Item key="3">
              <Link to="/risk-management">Risk Management</Link>
            </Menu.Item>
            <Menu.Item key="4">
              <Link to="/devices">Devices</Link>
            </Menu.Item>
          </Space>
        </Menu>
        <div style={{ marginLeft: "auto" }}>
          <Space>
            {modals && modals.length > 0 && <RightOutlined />}
            {modals?.map((value) => <>{value}</>)}
          </Space>
        </div>
      </Header>
      <Content style={{ padding: "0 50px" }}>
        <Breadcrumb style={{ margin: "16px 0" }}>
          <Breadcrumb.Item>Location: {useLocation().pathname}</Breadcrumb.Item>
        </Breadcrumb>
        <div
          className="site-layout-content"
          style={{ background: colorBgContainer, minHeight: "80vh" }}
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
