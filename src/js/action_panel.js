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
					          }
				        ]
			      }
		    ]
	  },
	  methods: {
		    // add random path
		    "addPath": function(sender, events){
			      var topo = this.topology;

			      let data = {"source": this.sourceIpAddress(),
						            "target": this.targetIpAddress(),
						            "cost": this.cost(),
						            "color": getColor(),
                        "name": this.name(),
                       };

			      fetch("http://localhost:5000/path", {
				        method: "POST",
				        headers: {
					          "Content-Type": "application/json",
				        },
			  	      body: JSON.stringify(data),
			      })
			          .then((response) => response.json())
			          .then((data) => {
				            let ids = [];
				            for (let i = 0; i < data["links"].length; i++) {
					              let data_json = data["links"][i];
					              topo.addLink(
						                data_json
					              );
					              ids.push(data_json["id"]);
				            }
				            if (data["links"].length >= 1) {
					              let firstLink = data["links"][0];
					              let linksLength = data["links"].length;
					              addTableRecord(this.name(), firstLink["color"], firstLink["cost"], ids, topo);
				            }
			          })
			          .catch((error) => {
				            console.error("ERROR:", error);
			          });
		    },
	  }
});

function addTableRecord(name, color, cost, ids, topo) {
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

	  // add remove
	  let td3 = document.createElement("td");
	  let a = document.createElement("a");
	  a.innerHTML = "X";
	  a.href = "#";
	  a.onclick = function() {
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
    console.log(colorIndex);
    if (colorIndex >= colors.length) {
        colorIndex = 0;
    }

    return colors[colorIndex];
}

