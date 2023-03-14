
(function (nx) {
    /**
     * NeXt UI based application
     */
    // Initialize topology
    let topology = new nx.graphic.Topology({
        // View dimensions
        width: 1920,
        height: 800,
        // Dataprocessor is responsible for spreading
        // the Nodes across the view.
        // 'force' data processor spreads the Nodes so
        // they would be as distant from each other
        // as possible. Follow social distancing and stay healthy.
        // 'quick' dataprocessor picks random positions
        // for the Nodes.
        dataProcessor: 'force',
        // Node and Link identity key attribute name
        identityKey: 'id',
        // Node settings
        nodeConfig: {
            label: 'model.name',
            iconType:'model.icon',
        },
        // Link settings
        linkConfig: {
            // Display Links as curves in case of
            // multiple links between Node Pairs.
            // Set to 'parallel' to use parallel links.
            linkType: 'parallel',
            srcIfName: 'model.srcIfName',
            tgtIfName: 'model.tgtIfName',
            labelText: 'model.labelText',
            labelTextColor: 'model.labelTextColor',
            color: function(model) {
                if (model._data.color) {
                    return model._data.color
                }
            },
            width: function(model) {
                if (model._data.width) {
                    return model._data.width
                }
            },
            dotted: function(model) {
                if (model._data.dotted) {
                    return model._data.dotted
                }
            },
        },
        linkSetConfig: {
            collapsedRule: false,
        },
        // Display Node icon. Displays a dot if set to 'false'.
        showIcon: true,
        // Hide navigation
        showNavigation: false,
        // Link extension to add interface labels
        linkInstanceClass: "LinkExtension",
        // Tooltip extensions to add custom descriptions
        tooltipManagerConfig: {
            nodeTooltipContentClass: 'NodeTooltipExtension',
            linkTooltipContentClass: 'LinkTooltipExtension',
},
    });

    let Shell = nx.define(nx.ui.Application, {
        methods: {
            start: function () {
                // Read topology data from variable
                topology.data(topologyData);

                // Attach it to the document
                topology.attach(this);
                let actionPanel = new ActionPanel();
                actionPanel.topology = topology;

                actionPanel.attach(this);
            }
        }
    });

    // Create an application instance
    let shell = new Shell();
    // Run the application
    shell.start();
})(nx);


function buildTable() {
    //gather data
    //if data found, build table

    // if (!topologyData.paths) {
    //     return;
    // }

    let path;

    let mainTableElement = document.querySelector("#table");

    let table = document.createElement("table");
    table.classList.add("table-structure");

    let thead = document.createElement("thead")
    let tr1 = document.createElement("tr")
    let th1 = document.createElement("th")
    th1.classList.add("table-header");
    let th2 = document.createElement("th")
    th2.innerHTML = "Cost";
    th2.classList.add("table-header");
    let th3 = document.createElement("th")
    th3.innerHTML = "Remove";
    th3.classList.add("table-header");
    tr1.appendChild(th1);
    tr1.appendChild(th2);
    tr1.appendChild(th3);
    thead.appendChild(tr1);

    let tbody = document.createElement("tbody");
    tbody.id = "tableBody";

    let tr2 = document.createElement("tr");

    let td1 = document.createElement("td");
    td1.classList.add("table-column1");
    let td2 = document.createElement("td");
    td2.classList.add("table-column2");
    let td3 = document.createElement("td");
    td3.classList.add("table-column3");

    let span = document.createElement("span");
    span.innerHTML = "_______"
    span.style.color = "lightblue";
    td1.appendChild(span);

    td2.innerHTML = "0";

    td3.innerHTML = ""

    tr2.appendChild(td1);
    tr2.appendChild(td2);
    tr2.appendChild(td3);

    tbody.appendChild(tr2);

    table.appendChild(thead);
    table.appendChild(tbody);

    mainTableElement.appendChild(table);
}

buildTable();

