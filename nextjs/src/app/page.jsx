'use client'
import React, {useState} from "react";
import {TopBorder, BottomBorder, LeftBorder} from "./Border"
import './styles.css';
import {BrowserRouter, Route, Routes} from 'react-router-dom';

import Topology from "./topology";
import ApplicationGroups from "./application_groups";

const isBrowser = typeof window !== 'undefined';

export default function Page() {
    const [leftBorderOpen, setLeftBorderOpen] = useState(false);

    const toggleLeftBorder = () => {
        setLeftBorderOpen(!leftBorderOpen);
    };

    if (!isBrowser) {
        return null;
    }

    return (
        <div className="top-bottom-container">
            <TopBorder toggleLeftBorder={toggleLeftBorder}/>
            <div className="middle-container">
                <BrowserRouter>
                    <LeftBorder leftBorderOpen={leftBorderOpen}/>
                    <Routes>
                        <Route exact path='/' element={<Topology/>}>
                        </Route>
                        <Route path='/business-process' element={<ApplicationGroups/>}>
                        </Route>
                    </Routes>
                </BrowserRouter>
            </div>
            <BottomBorder/>
        </div>
    );
}
