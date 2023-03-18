(function (nx) {
    config = {
        width: 1920,
        height: 800,
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

    let topology = new nx.graphic.Topology(config);

    let App = nx.define(nx.ui.Application, {
        methods: {
            start: function () {
                topology.attach(this);

                let actionPanel = new ActionPanel();
                actionPanel.topology = topology;
                actionPanel.attach(this);
            }
        }
    });

    let app = new App();
    app.start();
})(nx);


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

    let tbody = document.createElement("tbody");
    tbody.id = "tableBody";

    table.appendChild(thead);
    table.appendChild(tbody);

    mainTableElement.appendChild(table);
}

buildTable();
