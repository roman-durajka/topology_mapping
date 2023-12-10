import { useEffect, useRef, useState } from "react";

import request from "./Requester";
import TopologyConnector from "../TopologyConnector";
import CustomLayout from "../CustomLayout";
import { CustomFunction, PathTableItem } from "./types";
import PathTable from "./PathTable";

function Topology() {
  const topologyContainer = useRef(null);
  const [topologyRequestData, setTopologyRequestData] = useState({});
  const [pathRequestData, setPathRequestData] = useState({});
  const [pathTableData, setPathTableData] = useState([]);
  const connector = useRef(new TopologyConnector());

  useEffect(() => {
    if (topologyContainer.current) {
      connector.current.init(topologyContainer.current);

      request({
        setState: setTopologyRequestData,
        url: "http://localhost:5000/topology",
        method: "GET",
      });
    }
  }, []);

  useEffect(() => {
    if (Object.keys(topologyRequestData).length) {
      connector.current.loadTopology(topologyRequestData);

      //if topology is loaded, load paths
      request({
        setState: setPathRequestData,
        url: "http://localhost:5000/load-paths",
        method: "GET",
      });
    }
  }, [topologyRequestData]);

  useEffect(() => {
    if (Object.keys(pathRequestData).length) {
      connector.current.loadPaths(pathRequestData);
      const pathTableData: object[] =
        connector.current.formatPathTableData(pathRequestData);
      setPathTableData(pathTableData);
    }
  }, [pathRequestData]);

  const funs: CustomFunction[] = [
    {
      name: "TEST",
      fun: () => {
        console.log("TOTO JE TEST");
      },
    },
  ];

  return (
    <CustomLayout customFunctions={funs}>
      <div className="TopologyContent" ref={topologyContainer}></div>
      <PathTable items={pathTableData} />
    </CustomLayout>
  );
}

export default Topology;
