'use client'
import React, {useState, useEffect} from 'react';
import axios from "axios";
import {Link} from "react-router-dom";
import {TopBorder, BottomBorder, LeftBorder} from "@/app/Border"
import '@/app/styles.css';

function AssetList() {
    const [assets, setAssets] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get("http://localhost:5000/assets")
            .then((response) => {
                setAssets(response.data);
            })
            .catch((error) => {
                console.error("API request error:", error);
            })
            .finally(() => {
                setLoading(false);
            });
    }, []); //

    return (
        <div className="asset-map-content">
            {loading ? (
                <div className="spinner-container">
                    <img src="/spinner.gif" alt="Loading..." className="spinner"/>
                </div>
            ) : (
                <div className="asset-list">
                    {Object.keys(assets).map((deviceID) => {
                        const device = assets[deviceID];
                        const risks = Object.keys(device["risks"]).map((riskUUID) => device["risks"][riskUUID]);
                        return (
                            <div className="asset-table">
                                <div className="asset-row asset-header">
                                    <div className="device-id-header device-id">ID</div>
                                    <div className="device-name-header device-name">Device Name</div>
                                    <div className="vulnerability-header vulnerability">Vulnerability</div>
                                    <div className="threat-header threat">Threat</div>
                                    <div className="asset-details-header asset-details">Details</div>
                                </div>

                                {risks.map((risk, index) => (
                                    <div className="asset-row" key={deviceID}>
                                        <div className="device-id">{deviceID}</div>
                                        <div className="device-name">{device.name}</div>
                                        <div className="vulnerability">{risk.vulnerability}</div>
                                        <div className="threat">{risk.threat}</div>
                                        <div className="asset-details"><span>&rarr;</span></div>
                                    </div>
                                ))}
                            </div>
                        )
                            ;
                    })}
                </div>
            )}
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
                <AssetList/>
            </div>
            <BottomBorder/>
        </div>
    );
}

export default App;
