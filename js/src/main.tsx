import ReactDOM from "react-dom/client";
import { createHashRouter, RouterProvider } from "react-router-dom";

import Topology from "./components/Topology.tsx";
import ErrorPage from "./components/Error.tsx";
import ApplicationGroups from "./components/ApplicationGroups.tsx";
import Devices from "./components/Devices.tsx";
import { TopologyConnector } from "./TopologyConnector.js";
import RiskManagement from "./components/RiskManagement.tsx";

const topologyConnector: TopologyConnector = new TopologyConnector();
topologyConnector.init();

const router = createHashRouter([
  {
    path: "/",
    element: <Topology connector={topologyConnector} />,
    errorElement: <ErrorPage />,
  },
  {
    path: "business-process",
    element: <ApplicationGroups />,
    errorElement: <ErrorPage />,
  },
  {
    path: "risk-management",
    element: <RiskManagement />,
    errorElement: <ErrorPage />,
  },
  {
    path: "devices",
    element: <Devices connector={topologyConnector} />,
    errorElement: <ErrorPage />,
  },
]);

ReactDOM.createRoot(document.getElementById("root")!).render(
  //  <React.StrictMode>
  <RouterProvider router={router} />,
  //  </React.StrictMode>,
);
