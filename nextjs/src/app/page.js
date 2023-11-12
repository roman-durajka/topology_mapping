'use client'
import React, {useState} from 'react';
import {TopBorder, BottomBorder, LeftBorder} from "./Border"
import './styles.css';


function App() {
    const [leftBorderOpen, setLeftBorderOpen] = useState(false);

    const toggleLeftBorder = () => {
        setLeftBorderOpen(!leftBorderOpen);
    };

    return (
        <div className="top-bottom-container">
            <TopBorder toggleLeftBorder={toggleLeftBorder}/>
            <div className="middle-container">
                <LeftBorder leftBorderOpen={leftBorderOpen}/>
                <iframe
                    src="/next_ui/index.html"
                    style={{height: '100%', width: '100%', border: 'none'}}
                    allowFullScreen
                />
            </div>
            <BottomBorder/>
        </div>
    );
}

export default App;