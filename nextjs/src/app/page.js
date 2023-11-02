'use client'
import React, {useState} from 'react';
import Button from './Button';
import './styles.css';

function TopBorder({toggleLeftBorder}) {
    return (
        <div className="border">
            <div className="left-content">
                <Button toggleLeftBorder={toggleLeftBorder}/>
            </div>
            <div className="center-content">
                <Title/>
            </div>
        </div>
    );
}

function Title() {
    return (
        <div className="title">
            Topology Mapping
        </div>
    );
}

function BottomBorder() {
    return (
        <div className="border bottom-border">
            <div className="github-link">
                <a href="https://github.com/roman-durajka" target="_blank" rel="noopener noreferrer">
                    GitHub: roman-durajka
                </a>
            </div>
        </div>
    );
}

function LeftBorder({leftBorderOpen}) {
    return (
        <div className={`left-border ${leftBorderOpen ? 'expanded' : ''}`}>
        </div>
    );
}

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