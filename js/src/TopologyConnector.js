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
  {
    label: "Business Process",
    propertyName: "businessProcess",
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
    this.application = null;
  }

  init() {
    let application = new window.nx.ui.Application();
    let topology = new window.nx.graphic.Topology(topologyConfig);

    this.topology = topology;
    this.application = application;
  }

  attach(componentElement) {
    this.application.container(componentElement);
    this.topology.attach(this.application, 0);
  }

  getNodeCoords() {
    let coords = {};

    let nodes = this.topology.getLayer("nodes").nodes();
    nodes.map((node) => {
      const nodeId = node.id();
      const x = node.x();
      const y = node.y();
      coords[nodeId] = { x_coord: x, y_coord: y };
    });

    return coords;
  }

  loadTopology(topologyData) {
    const processor = topologyData.data.dataProcessor;
    delete topologyData.data.dataProcessor;
    this.topology.sets({ dataProcessor: processor });
    this.topology.setData(topologyData.data);

    // if building topo for the first time
    // (using algorithm to get x and y coords)
    // save x,y coord to DB
    if (processor === "force") {
      const postData = { nodes: this.getNodeCoords() };
      request({
        url: "http://localhost:5000/topology-update",
        method: "POST",
        postData: postData,
      });
    }
  }

  updateAssetValue(node) {
    let assetValues = node.model().get("asset-values");
    let maxValue = Math.max(...assetValues);
    node.model().set("asset-value", maxValue);
  }

  addAssetValues(devices, assetValue) {
    devices.map((device) => {
      let node = this.topology.getNode(device);
      let assetValues = node.model().get("asset-values");
      assetValues.push(assetValue);
      node.model().set("asset-values", assetValues);

      this.updateAssetValue(node);
    });
  }

  removeAssetValues(devices, assetValue) {
    devices.map((device) => {
      let node = this.topology.getNode(device);
      let assetValues = node.model().get("asset-values");
      let valToRemoveIndex = assetValues.indexOf(assetValue);
      if (valToRemoveIndex !== -1) {
        assetValues.splice(valToRemoveIndex, 1);
      }
      node.model().set("asset-values", assetValues);

      this.updateAssetValue(node);
    });
  }

  loadPaths(pathData) {
    pathData.map((item) => {
      //add individual links
      item.links.map((link) => {
        this.topology.addLink(link);
      });
      //add asset values
      this.addAssetValues(item["nodes"], item["asset_value"]);
    });
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
          const postData = {
            pathId: Math.min(...ids),
            groupId: item.application_group_id,
          };
          request({
            url: "http://localhost:5000/remove-path",
            method: "POST",
            postData: postData,
          });
          //remove asset values
          this.removeAssetValues(item["nodes"], item["asset_value"]);
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

  getIfStartingIndex() {
    let nodes = this.topology.getLayer("nodes").nodes();
    let maxID = 0;
    nodes.map((node) => {
      const if_data = node.model().get("interfaces");
      Object.entries(if_data).map(([key, value]) => {
        const ifIndex = parseInt(value.split("/")[0], 10);
        if (ifIndex > maxID) {
          maxID = ifIndex;
        }
      });
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
