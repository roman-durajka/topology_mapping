import ReactDOM from "react-dom/client";
import { createBrowserRouter, RouterProvider } from "react-router-dom";

import Topology from "./components/Topology.tsx";
import ErrorPage from "./Error.tsx";
import "./index.css";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Topology />,
    errorElement: <ErrorPage />,
  },
]);

ReactDOM.createRoot(document.getElementById("root")!).render(
  //  <React.StrictMode>
  <RouterProvider router={router} />,
  //  </React.StrictMode>,
);
