import topologyConfig from "./config/topology-config";
import request from "./components/Requester";

//form object when adding path
export const addPathFormObject = [
  {
    label: "Path name",
    propertyName: "name",
  },
  {
    label: "Asset value",
    propertyName: "assetValue",
  },
  {
    label: "Source IP address",
    propertyName: "source",
  },
  {
    label: "Target IP address",
    propertyName: "target",
  },
  {
    label: "Color",
    propertyName: "color",
    selectOptions: ["red", "yellow", "green", "pink", "orange", "blue"],
  },
];

//form object when adding device

export const addDeviceFormObject = [
  {
    label: "Device name",
    propertyName: "name",
  },
  {
    label: "Model",
    propertyName: "model",
  },
  {
    label: "Operating system",
    propertyName: "os",
  },
  {
    label: "Device type",
    propertyName: "type",
    selectOptions: ["host", "l3sw", "router", "switch", "unknown"],
  },
  {
    label: "Asset",
    propertyName: "asset",
    selectOptions: ["server", "network"],
  },
];

export class TopologyConnector {
  constructor() {
    this.topology = null;
  }

  init(componentElement) {
    let application = new window.nx.ui.Application();
    let topology = new window.nx.graphic.Topology(topologyConfig);
    application.container(componentElement);
    topology.attach(application, 0);

    this.topology = topology;
  }

  loadTopology(topologyData) {
    this.topology.setData(topologyData.data);
  }

  loadPaths(pathData) {
    pathData.map((item) => {
      item.links.map((link) => {
        this.topology.addLink(link);
      });
    });
    //add asset values
  }

  //formats and returns path data to be used by table builder
  formatPathTableData(pathData) {
    let pathTableItems = [];

    pathData.map((item) => {
      let ids = [];
      item.links.map((link) => {
        ids.push(link.id);
      });
      pathTableItems.push({
        pathId: Math.min(...ids), //unique identifier so that the table record can be later removed
        name: item.name,
        assetValue: item.asset_value,
        color: item.links[0].color,
        fun: () => {
          //remove links from topology
          ids.map((id) => this.topology.removeLink(id));
          //send request to remove path from db
          const postData = { path_id: Math.min(...ids) };
          request({
            url: "http://localhost:5000/remove-path",
            method: "POST",
            postData: postData,
          });
        },
      });
    });

    return pathTableItems;
  }

  getPathStartingIndex() {
    let links = this.topology.getLayer("links").links();
    let maxID = 0;
    links.map((link) => {
      if (link.id() > maxID) {
        maxID = link.id();
      }
    });

    return maxID + 1;
  }

  getNodeStartingIndex() {
    let nodes = this.topology.getLayer("nodes").nodes();
    let maxID = 0;
    nodes.map((node) => {
      if (node.id() > maxID) {
        maxID = node.id();
      }
    });

    return maxID + 1;
  }

  addDevice(deviceData) {
    this.topology.addNode(deviceData);
  }

  addPath(pathData) {
    this.loadPaths([pathData]);
  }

  logNodes() {
    console.log(this.topology.getNodes());
  }
}
