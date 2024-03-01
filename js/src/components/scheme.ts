import { TopologyConnector } from "../TopologyConnector";
import originalJson from "../config/import-scheme.json";

function generateJsonFile(
  topologyConnector: TopologyConnector,
): string | undefined {
  if (topologyConnector.topology) {
    let resultingJson: string =
      "########## START WITH THESE VALUES WHEN ADDING NEW NODES AND INTERFACES, THEN DELETE THIS COMMMENT\n";
    resultingJson += `device_id: ${topologyConnector.getNodeStartingIndex()}\n`;
    resultingJson += `port_id: ${topologyConnector.getPathStartingIndex()}\n`;
    resultingJson += "##########\n\n";

    resultingJson += JSON.stringify(originalJson);

    const blob = new Blob([resultingJson], {
      type: "application/json",
    });
    return URL.createObjectURL(blob);
  }
}

export default generateJsonFile;
