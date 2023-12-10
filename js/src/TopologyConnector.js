import topologyConfig from "./config/topology-config";

class TopologyConnector {
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
    let data = pathData.data;
    data.map((item) => {
      item.links.map((link) => {
        this.topology.addLink(link);
      });
    });
    //add asset values
  }

  //formats and returns path data to be used by table builder
  formatPathTableData(pathData) {
    let pathTableItems = [];

    let data = pathData.data;
    data.map((item) => {
      let ids = [];
      item.links.map((link) => {
        ids.push(link.id);
      });
      pathTableItems.push({
        name: item.name,
        assetValue: item.asset_value,
        color: item.links[0].color,
        fun: () => {
          console.log(ids);
          //this.topology.removeLink(link.id);
          //TODO: removePath
        },
      });
    });

    return pathTableItems;
  }

  logNodes() {
    console.log(this.topology.getNodes());
  }
}

export default TopologyConnector;
