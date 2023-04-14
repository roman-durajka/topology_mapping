nx.define("ActionPanel", nx.ui.Component, {
    properties: {
        topology: {},
        activePaths: [],
        sourceIpAddress: "",
        targetIpAddress: "",
        cost: "",
        name: "",
    },
    view: {
        content: [
            {
                "tag": "div",
                "content": [
                    {
                        "tag": "span",
                        "content": " Name: ",
                    },
                    {
                        "tag": "input",
                        "props": {
                            "value": "{#name}"
                        }
                    },
                    {
                        "tag": "span",
                        "content": " Source IP: ",
                    },
                    {
                        "tag": "input",
                        "props": {
                            "value": "{#sourceIpAddress}"
                        }
                    },
                    {
                        "tag": "span",
                        "content": " Destination IP: ",
                    },
                    {
                        "tag": "input",
                        "props": {
                            "value": "{#targetIpAddress}"
                        }
                    },
                    {
                        "tag": "span",
                        "content": " Asset-value: ",
                    },
                    {
                        "tag": "input",
                        "props": {
                            "value": "{#cost}"
                        }
                    },
                    {
                        "tag": "span",
                        "content": "   ",
                    },
                    {
                        "tag": "button",
                        "content": " Draw path ",
                        "events": {
                            "click": "{#addPath}"
                        }
                    },
                    {
                        "tag": "button",
                        "content": " Draw topology ",
                        "events": {
                            "click": "{#createTopology}"
                        },
                        "props": {
                            "class": "t-button"
                        }
                    }
                ]
            }
        ]
    },
    methods: {
        "addPath": function (sender, events) {
            var topo = this.topology;

            // get highest index so the indexing can continue
            let links = topo.getLayer("links").links();
            let startIndex = 1;
            let linkIndex = 0;
            for (let dictIndex in links) {
                linkIndex = links[dictIndex].id() + 1;
                if (linkIndex > startIndex) {
                    startIndex = linkIndex;
                }
            }

            let inputData = {
                "source": this.sourceIpAddress(),
                "target": this.targetIpAddress(),
                "color": getColor(),
                "startingIndex": startIndex
            };

            fetch("http://localhost:5000/path", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(inputData),
            })
                .then((response) => response.json())
                .then((data) => {
                    if (data["code"] !== 200) {
                        window.alert("ERROR: Could not create path.\n" + data["error"]);
                    } else {
                        let ids = [];
                        for (let i = 0; i < data["links"].length; i++) {
                            let data_json = data["links"][i];
                            topo.addLink(
                                data_json
                            );
                            ids.push(data_json["id"]);
                        }
                        if (data["links"].length >= 1) {
                            addTableRecord(this.name(), inputData["color"], this.cost(), ids, topo, data["nodes"]);
                        }
                        addAssetValues(data["nodes"], this.cost(), topo);
                    }
                })
                .catch((error) => {
                    window.alert("ERROR: Could not create path. For detailed report check console or system runtime logs.");
                    console.error("ERROR:", error);
                });
        },
        "createTopology": function (sender, events) {
            let topo = this.topology;

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
    }
});


function addAssetValues(devices, cost, topo) {
    for (let i = 0; i < devices.length; i++) {
        let node = topo.getNode(devices[i]);
        let assetValues = node.model().get("asset-values");
        assetValues.push(cost);
        node.model().set("asset-values", assetValues)

        updateDeviceAssetValue(node);
    }
}


function removeAssetValues(devices, cost, topo) {
    for (let i = 0; i < devices.length; i++) {
        let node = topo.getNode(devices[i]);
        let assetValues = node.model().get("asset-values");
        let valToRemoveIndex = assetValues.indexOf(cost);
        if (valToRemoveIndex !== -1) {
            assetValues.splice(valToRemoveIndex, 1);
        }
        node.model().set("asset-values", assetValues)

        updateDeviceAssetValue(node);
    }
}


function updateDeviceAssetValue(node) {
    let assetValues = node.model().get("asset-values");
    let maxValue = Math.max(...assetValues);
    node.model().set("asset-value", maxValue);
}


function addTableRecord(name, color, cost, ids, topo, devices) {
    let tbody = document.getElementById("tableBody");
    let tr1 = document.createElement("tr");

    // add name
    let td0 = document.createElement("td");
    let span0 = document.createElement("span");
    span0.innerHTML = name;
    td0.appendChild(span0);
    tr1.appendChild(td0);

    // add link
    let td1 = document.createElement("td");
    let span = document.createElement("span");
    span.innerHTML = "_ _ _ _ _ _";
    span.style.color = color;
    td1.appendChild(span);
    tr1.appendChild(td1);

    // add cost
    let td2 = document.createElement("td");
    td2.innerHTML = cost;
    tr1.appendChild(td2);

    // add remove functionality
    let td3 = document.createElement("td");
    let a = document.createElement("a");
    a.innerHTML = "X";
    a.href = "#";
    a.onclick = function () {
        removeAssetValues(devices, cost, topo)
        for (let i = 0; i < ids.length; i++) {
            topo.removeLink(ids[i]);
        }
        tbody.removeChild(tr1);
    };
    td3.appendChild(a);
    tr1.appendChild(td3);
    tbody.appendChild(tr1);
}


var colors = ["red", "green", "blue", "yellow", "orange", "pink"];
var colorIndex = 0;


function getColor() {
    colorIndex++;
    if (colorIndex >= colors.length) {
        colorIndex = 0;
    }

    return colors[colorIndex];
}
