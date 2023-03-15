nx.define("ActionPanel", nx.ui.Component, {
    properties: {
	    topology: {},
		activePaths: [],
		sourceIpAddress: "",
		targetIpAddress: "",
		cost: "",
		color: "",
    },
	view: {
		content: [
			{
				"tag": "div",
				"content": [
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
						"content": " Cost: ",
					},
					{
						"tag": "input",
						"props": {
							"value": "{#cost}"
						}
					},
					{
						"tag": "span",
						"content": " Color: ",
					},
					{
						"tag": "input",
						"props": {
							"value": "{#color}"
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
						"color": this.color()}

			fetch("http://localhost:5000/path", {
				method: "POST",
				headers: {
					"Content-Type": "application/json",
				  },
			  	body: JSON.stringify(data),
			})
			  .then((response) => response.json())
			  .then((data) => {
				let ids = []
				for (let i = 0; i < data["links"].length; i++) {
					let data_json = data["links"][i];
					topo.addLink(
						data_json
					)
					ids.push(data_json["id"]);
				}
				if (data["links"].length >= 1) {
					let firstLink = data["links"][0];
					let linksLength = data["links"].length;
					addTableRecord(firstLink["color"], firstLink["cost"], ids, topo);
				}
			  })
			  .catch((error) => {
				console.error("ERROR:", error);
			  });
		},
	}
});

function addTableRecord(color, cost, ids, topo) {
	let tbody = document.getElementById("tableBody");
	let tr1 = document.createElement("tr");

	// add link
	let td1 = document.createElement("td");
	let span = document.createElement("span");
    span.innerHTML = "_ _ _ _ _ _"
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
	}
	td3.appendChild(a);
	tr1.appendChild(td3);
	tbody.appendChild(tr1);
}
