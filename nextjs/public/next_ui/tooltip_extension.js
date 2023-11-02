let ILLEGAL_ATTRIBUTES = ["id", "index", "weight", "x", "y", "px", "py", "icon", "asset-values"]

nx.define('NodeTooltipExtension', nx.ui.Component, {
    properties: {
        node: {
            set: function (value) {
                let data = value.model().getData();
                let node_data = {};
                let if_data = {};
                let vulnerabilities_data = {};
                let threats_data = {};

                for (const [key, value] of Object.entries(data)) {
                    if (ILLEGAL_ATTRIBUTES.indexOf(key) === -1) {
                        if (key === "interfaces") {
                            for (const [if_key, if_value] of Object.entries(value)) {
                                if_data[if_key] = if_value;
                            }
                        } else if (key === "vulnerabilities"){
                            let i = 0;
                            for (const vulnerability_value of value) {
                                vulnerabilities_data[i] = vulnerability_value;
                                i++;
                            }
                        } else if (key === "threats"){
                            let i = 0;
                            for (const threats_value of value) {
                                threats_data[i] = threats_value;
                                i++;
                            }
                        } else {
                            node_data[key] = value;
                        }
                    }
                }

                this.view('list').set('items', new nx.data.Dictionary(node_data));
                this.view('if-list').set('items', new nx.data.Dictionary(if_data));
                this.view('vulnerabilities-list').set('items', new nx.data.Dictionary(vulnerabilities_data));
                this.view('threats-list').set('items', new nx.data.Dictionary(threats_data));
                this.title("Device description");
                console.log(new nx.data.Dictionary(node_data));
            }
        },
        topology: {},
        title: {}
    },
    view: {
        props: {"style": "width: 450px; height: 300px; overflow-y: scroll;"},
        content: [
            {
                name: 'header',
                props: {
                    'class': 'n-topology-tooltip-header'
                },
                content: [
                    {
                        tag: 'span',
                        props: {
                            'class': 'n-topology-tooltip-header-text'
                        },
                        name: 'title',
                        content: '{#title}'
                    }
                ]
            },
            {
                name: 'content',
                props: {
                    'class': 'n-topology-tooltip-content n-list'
                },
                content: [
                    {
                        name: 'list',
                        tag: 'ul',
                        props: {
                            'class': 'n-list-wrap',
                            template: {
                                tag: 'li',
                                props: {
                                    'class': 'n-list-item-i',
                                    role: 'listitem'
                                },
                                content: [
                                    {
                                        tag: 'label',
                                        content: '{key}'
                                    },
                                    {
                                        tag: 'span',
                                        content: '{value}'
                                    },
                                ]
                            }
                        }
                    }, {
                        name: "if",
                        tag: 'ul',
                        props: {
                            'class': 'n-list-wrap',
                            tag: 'li',
                            content: [
                                {
                                    tag: 'label',
                                    content: 'interfaces'
                                },
                                {
                                    tag: 'span',
                                    content: '(status/ip/mac)'
                                },
                                {
                                    name: 'if-list',
                                    tag: 'ul',
                                    props: {
                                        'class': 'n-list-wrap',
                                        template: {
                                            tag: 'li',
                                            props: {
                                                'class': 'n-list-item-i li-indent',
                                                role: 'listitem'
                                            },
                                            content: [
                                                {
                                                    tag: 'label',
                                                    content: '  {key}'
                                                },
                                                {
                                                    tag: 'span',
                                                    content: '{value}'
                                                },
                                            ]
                                        }
                                    }
                                },
                            ]
                        }
                    }, {
                        name: "vulnerabilities",
                        tag: 'ul',
                        props: {
                            'class': 'n-list-wrap',
                            tag: 'li',
                            content: [
                                {
                                    tag: 'label',
                                    content: 'vulnerabilities'
                                },
                                {
                                    name: 'vulnerabilities-list',
                                    tag: 'ul',
                                    props: {
                                        'class': 'n-list-wrap',
                                        template: {
                                            tag: 'li',
                                            props: {
                                                'class': 'n-list-item-i li-indent',
                                                role: 'listitem'
                                            },
                                            content: [
                                                {
                                                    tag: 'label',
                                                    content: '  -'
                                                },
                                                {
                                                    tag: 'span',
                                                    content: '{value}'
                                                }
                                            ]
                                        }
                                    }
                                }
                            ]
                        }
                    }, {
                        name: "threats",
                        tag: 'ul',
                        props: {
                            'class': 'n-list-wrap',
                            tag: 'li',
                            content: [
                                {
                                    tag: 'label',
                                    content: 'threats'
                                }, {
                                    name: 'threats-list',
                                    tag: 'ul',
                                    props: {
                                        'class': 'n-list-wrap',
                                        template: {
                                            tag: 'li',
                                            props: {
                                                'class': 'n-list-item-i li-indent',
                                                role: 'listitem'
                                            },
                                            content: [
                                                {
                                                    tag: 'label',
                                                    content: '  -'
                                                },
                                                {
                                                    tag: 'span',
                                                    content: '{value}'
                                                }
                                            ]
                                        }
                                    }
                                }
                            ]
                        }
                    }
                ]
            }
        ]
    },
    methods: {
        init: function (args) {
            this.inherited(args);
            this.sets(args);
        }
    }
});


nx.define("LinkTooltipExtension", nx.ui.Component, {
    properties: {
        link: {
            set: function (value) {
                let data = value.model().getData();
                this.view('list').set('items', new nx.data.Dictionary({
                    "Source interface:": data.srcIfName,
                    "Target interface:": data.tgtIfName,
                    "Source MAC": data.srcMac,
                    "Target MAC": data.tgtMac
                }));
                this.title("Link description");
            }
        },
        title: {},
        topology: {},
        tooltipmanager: {}
    },
    view: {
        props: {"style": "width: 280px;"},
        content: {
            props: {
                'class': 'n-topology-tooltip-content n-list'
            },
            content: [
                {
                    name: 'header',
                    props: {
                        'class': 'n-topology-tooltip-header'
                    },
                    content: [
                        {
                            tag: 'span',
                            props: {
                                'class': 'n-topology-tooltip-header-text'
                            },
                            name: 'title',
                            content: '{#title}'
                        }
                    ]
                },
                {
                    name: 'list',
                    tag: 'ul',
                    props: {
                        'class': 'n-list-wrap',
                        template: {
                            tag: 'li',
                            props: {
                                'class': 'n-list-item-i',
                                role: 'listitem'
                            },
                            content: [
                                {
                                    tag: 'label',
                                    content: '{key}: '
                                },
                                {
                                    tag: 'span',
                                    content: '{value}'
                                }
                            ]

                        }
                    }
                }
            ]
        }
    }
});
