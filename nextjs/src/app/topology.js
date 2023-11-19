import React from 'react';
import './styles.css';


function Topology() {
    return (
        <iframe
            src="/next_ui/index.html"
            style={{height: '100%', width: '100%', border: 'none'}}
            allowFullScreen
        />
    );
}

export default Topology;