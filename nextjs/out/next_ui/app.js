(function (nx) {
    let config = {
        width: window.innerWidth - 50,
        height: window.innerHeight - 100,
        dataProcessor: 'force',
        identityKey: 'id',
        nodeConfig: {
            label: 'model.name',
            iconType: 'model.icon',
        },
        linkConfig: {
            linkType: 'parallel',
            srcIfName: 'model.srcIfName',
            tgtIfName: 'model.tgtIfName',
            labelText: 'model.labelText',
            labelTextColor: 'model.labelTextColor',
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
            nodeTooltipContentClass: 'NodeTooltipExtension',
            linkTooltipContentClass: 'LinkTooltipExtension',
        },
    };

    let app = new nx.ui.Application();
    app.container(document.getElementById("topology-container"));
    let topology = new nx.graphic.Topology(config);
    topology.attach(app);
    let actionPanel = new ActionPanel();
    actionPanel.topology = topology;
    actionPanel.attach(app);

    createTopology(topology);
    setTimeout(() => loadPaths(topology), 1000);
})(nx);


function createTopology(topo) {
    fetch("http://localhost:5000/topology", {
        method: "GET"
    })
        .then((response) => response.json())
        .then((data) => {
            if (data["code"] !== 200) {
                window.alert("ERROR: Could not create topology.\n" + data["error"]);
            } else {
                let topologyData = data["data"];
                topo.setData(topologyData);
            }
        })
        .catch((error) => {
            window.alert("ERROR: Could not create topology. For detailed report check console or system runtime logs.");
            console.error("ERROR:", error);
        });
}


function loadPaths(topo) {
    fetch("http://localhost:5000/load-paths", {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        },
    })
        .then((response) => response.json())
        .then((data) => {
            if (data["code"] !== 200) {
                window.alert("ERROR: Could not load paths.\n" + data["error"]);
            } else {
                let paths_data = data["data"]

                for (let i = 0; i < paths_data.length; i++) {
                    let single_path_data = paths_data[i];

                    let ids = [];
                    for (let i = 0; i < single_path_data["links"].length; i++) {
                        let link_data_json = single_path_data["links"][i];
                        topo.addLink(
                            link_data_json
                        );
                        ids.push(link_data_json["id"]);
                    }

                    if (single_path_data["links"].length >= 1) {
                        addTableRecord(single_path_data["name"], single_path_data["links"][0]["color"], single_path_data["asset_value"], ids, topo, single_path_data["nodes"]);
                    }
                    addAssetValues(single_path_data["nodes"], single_path_data["asset_value"], topo);
                }
            }
        })
        .catch((error) => {
            window.alert("ERROR: Could not load paths. For detailed report check console or system runtime logs.");
            console.error("ERROR:", error);
        });
}


function buildTable() {
    let mainTableElement = document.querySelector("#table");

    let table = document.createElement("table");
    table.classList.add("table-structure");

    let thead = document.createElement("thead");
    let tr1 = document.createElement("tr");
    let th0 = document.createElement("th");
    th0.innerHTML = "Name";
    th0.classList.add("table-header");
    let th1 = document.createElement("th");
    th1.innerHTML = "Line";
    th1.classList.add("table-header");
    let th2 = document.createElement("th");
    th2.innerHTML = "Asset-value";
    th2.classList.add("table-header");
    let th3 = document.createElement("th");
    th3.innerHTML = "Remove";
    th3.classList.add("table-header");
    tr1.appendChild(th0);
    tr1.appendChild(th1);
    tr1.appendChild(th2);
    tr1.appendChild(th3);
    thead.appendChild(tr1);

    th0.classList.add("table-header");
    th1.classList.add("table-header");
    th2.classList.add("table-header");
    th3.classList.add("table-header");

    let tbody = document.createElement("tbody");
    tbody.id = "tableBody";

    table.appendChild(thead);
    table.appendChild(tbody);

    mainTableElement.appendChild(table);
}

buildTable();
