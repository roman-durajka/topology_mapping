import ReactDOM from "react-dom/client";
import { createHashRouter, RouterProvider } from "react-router-dom";

import Topology from "./components/Topology.tsx";
import ErrorPage from "./components/Error.tsx";
import ApplicationGroups from "./components/ApplicationGroups.tsx";

const router = createHashRouter([
  {
    path: "/",
    element: <Topology />,
    errorElement: <ErrorPage />,
  },
  {
    path: "business-process",
    element: <ApplicationGroups />,
    errorElement: <ErrorPage />,
  },
]);

ReactDOM.createRoot(document.getElementById("root")!).render(
  //  <React.StrictMode>
  <RouterProvider router={router} />,
  //  </React.StrictMode>,
);
