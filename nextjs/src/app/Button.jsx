'use client'
import React, {useState} from 'react';

function Button({toggleLeftBorder}) {
    return (
        <button className="toggle-button" onClick={toggleLeftBorder}>
        </button>
    );
}

export default Button;