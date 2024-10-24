import { useEffect } from "react";
import { useBlocker } from 'react-router-dom';
import type { Blocker } from "@remix-run/router";

const useUnsavedChangesGlobal = (isDirty: boolean) => {
    useEffect(() => {
        const handleBeforeUnload = (e: BeforeUnloadEvent) => {
            if (isDirty) {
                e.preventDefault();
            }
        };

        window.addEventListener('beforeunload', handleBeforeUnload);
        return () => {
            window.removeEventListener('beforeunload', handleBeforeUnload);
        };
    }, [isDirty]);
}

const useUnsavedChangesRouter = (isDirty: boolean) => {
        const blocker: Blocker = useBlocker(isDirty);
        if (blocker.state === "blocked") {
            const confirmData = window.confirm("You have unsaved data. Are you sure you want to continue?");
            if (confirmData) {
                blocker.proceed();
            } else {
                blocker.reset();
            }
        }
};

export {useUnsavedChangesGlobal, useUnsavedChangesRouter};