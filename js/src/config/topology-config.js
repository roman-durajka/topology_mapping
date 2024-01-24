let topologyConfig = {
  width: window.innerWidth - 100,
  height: window.innerHeight - 130,
  dataProcessor: "force",
  identityKey: "id",
  nodeConfig: {
    label: "model.name",
    iconType: "model.icon",
  },
  linkConfig: {
    linkType: "parallel",
    srcIfName: "model.srcIfName",
    tgtIfName: "model.tgtIfName",
    labelText: "model.labelText",
    labelTextColor: "model.labelTextColor",
    color: function (model) {
      if (model._data.color) {
        return model._data.color;
      }
    },
    width: function (model) {
      if (model._data.width) {
        return model._data.width;
      }
    },
    dotted: function (model) {
      if (model._data.dotted) {
        return model._data.dotted;
      }
    },
  },
  linkSetConfig: {
    collapsedRule: false,
  },
  showIcon: true,
  showNavigation: false,
  // link extension to add interface labels
  linkInstanceClass: "LinkExtension",
  // tooltip extensions to add custom descriptions
  tooltipManagerConfig: {
    nodeTooltipContentClass: "NodeTooltipExtension",
    linkTooltipContentClass: "LinkTooltipExtension",
  },
};

export default topologyConfig;
