import Button from "@/app/Button";
import React from "react";
import './styles.css';

function Title() {
    return (
        <div className="title">
            Topology Mapping
        </div>
    );
}

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
    const handleAssetsClick = () => {
    window.location.href = 'http://localhost:3000/assets';
  };

  const handleTopologyClick = () => {
    window.location.href = 'http://localhost:3000/';
  };

    return (
        <div className={`left-border ${leftBorderOpen ? 'expanded' : ''}`}>
            {leftBorderOpen && (
                <div className="left-border-buttons">
                    <button onClick={handleTopologyClick}>Topology</button>
                    <button onClick={handleAssetsClick}>Assets</button>
                </div>
            )}
        </div>
    );
}

export {TopBorder, BottomBorder, LeftBorder};
