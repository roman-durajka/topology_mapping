import Button from "./Button"
import React from "react";
import './styles.css';
import { Link } from 'react-router-dom';

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
    return (
        <div className={`left-border ${leftBorderOpen ? 'expanded' : ''}`}>
            {leftBorderOpen && (
                <div className="left-border-buttons">
                    <button><Link to="/">Topology</Link></button>
                    <button><Link to="/business-process">Business Processes</Link></button>
                </div>)}
        </div>
    );
}

export {TopBorder, BottomBorder, LeftBorder};
