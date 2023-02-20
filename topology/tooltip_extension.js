nx.define('NodeTooltipExtension', nx.ui.Component, {
        properties: {
            node: {
                set: function (value) {
                    let data = value.model().getData();
                    this.view('list').set('items', new nx.data.Dictionary({"Name:": data.name}));
                    this.title("Device description");
                }
            },
            topology: {},
            title: {}
        },
        view: {
            props: {"style": "width: 200px;"},
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
                                        }
                                    ]

                                }
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
        }});


nx.define("LinkTooltipExtension", nx.ui.Component, {
        properties: {
            link: {
                set: function (value) {
                    let data = value.model().getData();
                    this.view('list').set('items', new nx.data.Dictionary({"Source interface:": data.srcIfName,
                                                                            "Target interface:": data.tgtIfName}));
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
