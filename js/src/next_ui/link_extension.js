nx.define('LinkExtension', nx.graphic.Topology.Link, {
    properties: {
        srcIfName: null,
        tgtIfName: null,
        labelText: null,
        labelTextColor: null,
        linkSize: null,
        dotted: {
            set: function (inValue) {
                let lineEl = this.view('line');
                let value = this._processPropertyValue(inValue);
                if (value) {
                    lineEl.dom().setStyle('stroke-dasharray', '3, 2');
                } else {
                    lineEl.dom().setStyle('stroke-dasharray', '');
                }
                this._dotted = value;
            }
        },
    },
    view: function (view) {
        view.content.push(
            {
                name: 'rectangleSource',
                type: 'nx.graphic.Rect',
                props: {
                    height: 6,
                    fill: 'white'
                }
            },
            {
                name: 'rectangleTarget',
                type: 'nx.graphic.Rect',
                props: {
                    height: 6,
                    fill: 'white'
                }
            }, {
                name: 'source',
                type: 'nx.graphic.Text',
                props: {
                    'class': 'source-link-label',
                    'alignment-baseline': 'text-after-edge',
                    'text-anchor': 'start'
                }
            }, {
                name: 'target',
                type: 'nx.graphic.Text',
                props: {
                    'class': 'target-link-label',
                    'alignment-baseline': 'text-after-edge',
                    'text-anchor': 'end'
                }
            }, {
                name: 'labelText-attr',
                type: 'nx.graphic.Text',
                props: {
                    'class': 'link-labelText',
                }
            });
        return view;
    },
    methods: {
        update: function () {
            this.inherited();
            let label, position, rectangleSource, rectangleTarget;
            let line = this.line();
            line = line.pad(22 * this.stageScale(), 22 * this.stageScale());
            if (this.srcIfName()) {
                position = line.start;

                rectangleSource = this.view("rectangleSource");
                rectangleSource.set('x', position.x);
                rectangleSource.set('y', position.y - 10 * this.stageScale());
                rectangleSource.set('transform', 'rotate(' + line.angle() + ' ' + position.x + ',' + position.y + ')');
                rectangleSource.set('width', this.srcIfName().length * this.stageScale() * 5);
                rectangleSource.set('height', this.stageScale() * 10);

                label = this.view('source');
                label.set('x', position.x);
                label.set('y', position.y);
                label.set('text', this.srcIfName());
                label.set('transform', 'rotate(' + line.angle() + ' ' + position.x + ',' + position.y + ')');
                label.setStyle('font-size', 11 * this.stageScale());
            }
            if (this.tgtIfName()) {
                position = line.end;

                rectangleTarget = this.view("rectangleTarget");
                rectangleTarget.set('x', position.x - this.tgtIfName().length * this.stageScale() * 5.5);
                rectangleTarget.set('y', position.y - 10 * this.stageScale());
                rectangleTarget.set('transform', 'rotate(' + line.angle() + ' ' + position.x + ',' + position.y + ')');
                rectangleTarget.set('width', this.tgtIfName().length * this.stageScale() * 6);
                rectangleTarget.set('height', this.stageScale() * 10);

                label = this.view('target');
                label.set('x', position.x);
                label.set('y', position.y);
                label.set('text', this.tgtIfName());
                label.set('transform', 'rotate(' + line.angle() + ' ' + position.x + ',' + position.y + ')');
                label.setStyle('font-size', 12 * this.stageScale());
            }
            if (this.labelText()) {
                position = line.center();
                label = this.view('labelText-attr');
                label.set('x', position.x);
                label.set('y', position.y);
                label.set('text', this.labelText());
                label.setStyle('font-size', 12 * this.stageScale());
                if (this.labelTextColor()) {
                    label.setStyle("fill", this.labelTextColor());
                }
            }
        }
    }
});
