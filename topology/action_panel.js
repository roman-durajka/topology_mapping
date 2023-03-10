nx.define("ActionPanel", nx.ui.Component, {
    properties: {
	    topology: {},
		activePaths: [],
		sourceIpAddress: "",
		targetIpAddress: "",
    },
	view: {
		content: [
			{
				"tag": "div",
				"content": [
					{
						"tag": "input",
						"props": {
							"value": "{#sourceIpAddress}"
						}
					},
					{
						"tag": "input",
						"props": {
							"value": "{#targetIpAddress}"
						}
					},
					{
						"tag": "button",
						"content": "Save",
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
			postData(this.sourceIpAddress(), this.targetIpAddress(), "5")

			function postData(source, destination, value) {
				$.ajax({
					data: 'source=' + source + "destination=" + destination + "value=" + value,
					url: 'action_panel_request.php',
					method: 'POST',
					success: callbackFunc
				});
			}


			// function postData(source, destination, value) {
			// 	$.ajax({
			// 		type: "POST",
			// 		url: "/path ",
			// 		data: { param: source, destination, value },
			// 		success: callbackFunc
			// 	});
			// }

			function callbackFunc(response) {
				console.log(response);
				let data = response.data;

				for (const link of data) {
					topo.addLink(link);
				}
				this.activePaths = response.pathID;

			}



            // var pathLayer = topo.getLayer("paths");
            // let opacity = 0.8;
            // let pathWidth = 1;



		// 	console.log(this.ipAddress());
		//
		// 	topo.addLink({
        //     "id": 1234,
        //     "source": 41,
        //     "srcIfName": "Fa0/0",
        //     "srcMac": "ec447682dae0",
        //     "target": 51,
        //     "tgtIfName": "Fa0/13",
        //     "tgtMac": "0023ead39c0d"
        // })
		},
		// clear paths
		"onClearPaths": function(sender, events){
			// todo: add code
		}
	}
});