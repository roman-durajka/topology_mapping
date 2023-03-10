nx.define('LinkExtension', nx.graphic.Topology.Link, {
    properties: {
        srcIfName: null,
        tgtIfName: null,
        labelText: null,
        labelTextColor: null,
        linkSize: null,
        dotted: {
                set: function(inValue) {
                    var lineEl = this.view('line');
                    var value = this._processPropertyValue(inValue);
                    if (value) {
                        lineEl.dom().setStyle('stroke-dasharray', '3, 2');
                    } else {
						lineEl.dom().setStyle('stroke-dasharray', '');
                    }
                    this._dotted = value;
                }
            },
    },
    view: function(view) {
        view.content.push({
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
        update: function() {
            this.inherited();
            let label, position;
            let line = this.line();
            line = line.pad(22 * this.stageScale(), 22 * this.stageScale());
            if (this.srcIfName()) {
                position = line.start;
                label = this.view('source');
                label.set('x', position.x);
                label.set('y', position.y);
                label.set('text', this.srcIfName());
                label.set('transform', 'rotate(' + line.angle() + ' ' + position.x + ',' + position.y + ')');
                label.setStyle('font-size', 11 * this.stageScale());
            }
            if (this.tgtIfName()) {
                position = line.end;
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
                label.set('x', position.x + 5);
                label.set('y', position.y + 20);
                label.set('text', this.labelText());
                label.setStyle('font-size', 12 * this.stageScale());
                if (this.labelTextColor()) {
                    label.setStyle("fill", this.labelTextColor());
                }
            }
        }
    }
});
