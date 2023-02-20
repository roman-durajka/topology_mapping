nx.define('LinkExtension', nx.graphic.Topology.Link, {
    properties: {
        srcIfName: null,
        tgtIfName: null
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
        }
    }
});
