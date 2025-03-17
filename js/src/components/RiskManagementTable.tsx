import {StringIndexedObject} from "./types.tsx";
import {Select, Table} from "antd";
import request from "./Requester.tsx";
import {useCallback, useEffect, useState} from "react";

const riskManagementColumns: object[] = [
    {
        title: "Asset category",
        dataIndex: "assetName",
        width: "10%",
    },
    {
        title: "Impact",
        children: [
            {
                title: "C",
                dataIndex: "impactC",
                width: "6%",
            },
            {
                title: "I",
                dataIndex: "impactI",
                width: "6%",
            },
            {
                title: "A",
                dataIndex: "impactA",
                width: "6%",
            },
        ],
    },
    {
        title: "Threat",
        children: [
            {
                title: "Label",
                dataIndex: "threatName",
                width: "10%",
            },
            {
                title: "Prob.",
                dataIndex: "threatProbability",
                width: "6%",
            },
        ],
    },
    {
        title: "Vulnerability",
        children: [
            {
                title: "Label",
                dataIndex: "vulnerabilityName",
                width: "10%",
            },
            {
                title: "Qualif.",
                dataIndex: "vulnerabilityQualification",
                width: "6%",
            },
        ],
    },
    {
        title: "Current risk",
        children: [
            {
                title: "C",
                dataIndex: "currentRiskC",
                width: "5%",
            },
            {
                title: "I",
                dataIndex: "currentRiskI",
                width: "5%",
            },
            {
                title: "A",
                dataIndex: "currentRiskA",
                width: "5%",
            },
        ],
    },
    {
        title: "Treatment",
        children: [
            {
                title: "Label",
                dataIndex: "treatmentLabel",
                width: "30%",
            },
            {
                title: "Effect.",
                dataIndex: "treatmentEffectiveness",
                width: "6%",
            },
        ],
    },
    {
        title: "Risk after treatment",
        children: [
            {
                title: "C",
                dataIndex: "riskAfterTreatmentC",
                width: "5%",
            },
            {
                title: "I",
                dataIndex: "riskAfterTreatmentI",
                width: "5%",
            },
            {
                title: "A",
                dataIndex: "riskAfterTreatmentA",
                width: "5%",
            },
        ],
    },
];

function getSelectableCell(
    defaultValue: any,
    values: any[],
    save: (value: StringIndexedObject) => void,
) {
    return (
        <Select
            key={`${defaultValue}-${Math.random()}`}
            onChange={save}
            defaultValue={defaultValue}
            options={values.map((selectedValue) => ({
                value: selectedValue,
                label: selectedValue,
            }))}
            style={{
                width: '100%',
            }}
        ></Select>
    );
}

interface InterfaceRiskManagementTable {
    deviceData: StringIndexedObject;
    deviceId: string;
}

const RiskManagementTable: React.FC<InterfaceRiskManagementTable> = ({ deviceData, deviceId }) => {
    const [tableData, setTableData] = useState<object[]>([]);

    const updateCellValue = useCallback((rowKey: string, field: string, newValue: StringIndexedObject | string, keyToUpdate: string, values: object, currentUUID: string | null) => {
        setTableData((prevData: any[]) =>
            prevData.map((row) => {
                if (row.key === rowKey) {
                    const updatedRow = { ...row };
                    if (currentUUID != null && !updatedRow["currentTreatmentUUID"]) {
                        updatedRow["currentTreatmentUUID"] = currentUUID;
                    }
                    if (Object.keys(values).length > 0 && !updatedRow.treatments) {
                        updatedRow.treatments = values;
                    }

                    if (keyToUpdate === "treatmentEffectiveness") { //updateCellValue(assetKey, currentTreatmentUUID, newValue, "treatmentEffectiveness", []);
                        updatedRow["treatments"][field]["effectiveness"] = newValue;
                    }
                    else if (field === "currentTreatmentUUID") {
                        updatedRow["currentTreatmentUUID"] = String(newValue);

                        let currentTreatment: string = "";
                        if (updatedRow["currentTreatmentUUID"] !== "") {
                            currentTreatment = updatedRow["treatments"][updatedRow["currentTreatmentUUID"]]["name"];
                        }

                        const treatments: any = [
                            ...Object.keys(updatedRow.treatments).map(
                                (measureUUID: string) => updatedRow["treatments"][measureUUID]["name"]
                            ),
                            ""
                        ];

                        updatedRow["treatmentLabel"] = getSelectableCell(currentTreatment, treatments, (value) => {
                            Object.keys(updatedRow.treatments).forEach((measureUUID: string) => {
                                if (String(value) === "") {
                                    measureUUID = "";
                                }
                                if (String(value) === "" || updatedRow["treatments"][measureUUID]["name"] === value) {
                                    request({
                                        url: "http://localhost:5000/risk-management-update",
                                        method: "POST",
                                        postData: { uuid: rowKey, treatment: measureUUID },
                                    });
                                    updateCellValue(rowKey, "currentTreatmentUUID", measureUUID, "uuid", [], null);
                                }
                            });
                        });

                        updatedRow["treatmentEffectiveness"] = getSelectableCell(
                            newValue === "" ? 0 : updatedRow["treatments"][String(newValue)]["effectiveness"],
                            [1, 2, 3, 4, 5],
                            (newEffectiveness: StringIndexedObject) => {
                                if (String(newValue) !== "") {
                                    request({
                                        url: "http://localhost:5000/risk-management-update",
                                        method: "POST",
                                        postData: {uuid: newValue, effectiveness: newEffectiveness},
                                    });
                                    updateCellValue(rowKey, String(newValue), newEffectiveness, "treatmentEffectiveness", [], null);
                                    updateCellValue(rowKey, "currentTreatmentUUID", newValue, "uuid", [], null);
                                }
                            },
                        )
                    } else {
                        updatedRow[field] = getSelectableCell(
                            newValue,
                            [1, 2, 3, 4, 5],
                            (updatedValue: StringIndexedObject) => {
                                request({
                                    url: "http://localhost:5000/risk-management-update",
                                    method: "POST",
                                    postData: {uuid: rowKey, [keyToUpdate]: updatedValue},
                                });
                                updateCellValue(rowKey, field, updatedValue, keyToUpdate, [], null);
                            }
                        );
                    }

                    updatedRow.currentRiskC =
                        updatedRow.impactC.props.defaultValue *
                        updatedRow.threatProbability.props.defaultValue *
                        updatedRow.vulnerabilityQualification.props.defaultValue;
                    updatedRow.currentRiskI =
                        updatedRow.impactI.props.defaultValue *
                        updatedRow.threatProbability.props.defaultValue *
                        updatedRow.vulnerabilityQualification.props.defaultValue;
                    updatedRow.currentRiskA =
                        updatedRow.impactA.props.defaultValue *
                        updatedRow.threatProbability.props.defaultValue *
                        updatedRow.vulnerabilityQualification.props.defaultValue;

                    let currentTreatmentEffectiveness = 0
                    if (updatedRow["currentTreatmentUUID"] !== "") {
                        currentTreatmentEffectiveness = updatedRow["treatments"][updatedRow["currentTreatmentUUID"]]["effectiveness"]
                    }

                    updatedRow.riskAfterTreatmentC =
                        Math.max(
                            0,
                            updatedRow.currentRiskC - currentTreatmentEffectiveness
                        );
                    updatedRow.riskAfterTreatmentI =
                        Math.max(
                            0,
                            updatedRow.currentRiskI - currentTreatmentEffectiveness
                        );
                    updatedRow.riskAfterTreatmentA =
                        Math.max(
                            0,
                            updatedRow.currentRiskA - currentTreatmentEffectiveness
                        );

                    return updatedRow;
                }
                return row;
            })
        );
    }, []);

    useEffect(() => {
        const mappedRiskManagement: object[] = [];
        const riskManagementData: StringIndexedObject = deviceData["asset"];

        Object.keys(riskManagementData).forEach((assetUUID: string) => {
            const assetData: StringIndexedObject = riskManagementData[assetUUID];
            const asset: string = assetData["asset_name"];

            const risks: StringIndexedObject = assetData["risks"];
            Object.keys(risks).forEach((riskUUID: string) => {
                const risk: StringIndexedObject = risks[riskUUID];

                const threatObj: any = Object.values(risk["threat"])[0];
                const vulnerabilityObj: any = Object.values(risk["vulnerability"])[0];

                const threat: any = threatObj["name"];
                const vulnerability: any = vulnerabilityObj["name"];

                const threatProb: any = risk["threat_prob"];
                const vulnerabilityQual: any = risk["vulnerability_qualif"];
                const assetKey: string = `${deviceId}-${riskUUID}`;

                const treatments: any = [
                    ...Object.keys(risk["measures"]).map(
                        (measureUUID: string) => risk["measures"][measureUUID]["name"]
                    ),
                    ""
                ];
                const currentTreatmentUUID: string = risk["treatment"];
                const currentTreatment: string = currentTreatmentUUID
                    ? risk["measures"][currentTreatmentUUID]["name"]
                    : "";

                const currentTreatmentEffectiveness: number = currentTreatmentUUID
                    ? risk["measures"][currentTreatmentUUID]["effectiveness"]
                    : 0;

                setTableData((prevData: any[]) =>
                    prevData.map((row) => {
                        if (row.key === assetKey) {
                            const updatedRow = { ...row };
                            if (!updatedRow["treatments"]) {
                                updatedRow["treatments"] = {}
                            }
                            if (!updatedRow["treatments"][currentTreatmentUUID]) {
                                updatedRow["treatments"][currentTreatmentUUID] = {}
                            }
                            updatedRow["treatments"][currentTreatmentUUID]["effectiveness"] = currentTreatmentEffectiveness;
                            updatedRow["currentTreatmentUUID"] = currentTreatmentUUID;

                            return updatedRow;
                        }
                        return row;
                    })
                );

                mappedRiskManagement.push({
                    key: assetKey,
                    assetName: asset,
                    threatName: threat,
                    vulnerabilityName: vulnerability,

                    impactC: getSelectableCell(
                        risk["c"],
                        [1, 2, 3, 4, 5],
                        (newValue: StringIndexedObject) => {
                            request({
                                url: "http://localhost:5000/risk-management-update",
                                method: "POST",
                                postData: { uuid: assetKey, c: newValue },
                            });
                            updateCellValue(assetKey, "impactC", newValue, "c", risk["measures"], currentTreatmentUUID);
                        },
                    ),
                    impactI: getSelectableCell(
                        risk["i"],
                        [1, 2, 3, 4, 5],
                        (newValue: StringIndexedObject) => {
                            request({
                                url: "http://localhost:5000/risk-management-update",
                                method: "POST",
                                postData: { uuid: assetKey, i: newValue },
                            });
                            updateCellValue(assetKey, "impactI", newValue, "i", risk["measures"], currentTreatmentUUID);
                        },
                    ),
                    impactA: getSelectableCell(
                        risk["a"],
                        [1, 2, 3, 4, 5],
                        (newValue: StringIndexedObject) => {
                            request({
                                url: "http://localhost:5000/risk-management-update",
                                method: "POST",
                                postData: { uuid: assetKey, a: newValue },
                            });
                            updateCellValue(assetKey, "impactA", newValue, "a", risk["measures"], currentTreatmentUUID);
                        },
                    ),
                    threatProbability: getSelectableCell(
                        threatProb,
                        [1, 2, 3, 4, 5],
                        (newValue: StringIndexedObject) => {
                            request({
                                url: "http://localhost:5000/risk-management-update",
                                method: "POST",
                                postData: { uuid: assetKey, threat_prob: newValue },
                            });
                            updateCellValue(assetKey, "threatProbability", newValue, "threat_prob", risk["measures"], currentTreatmentUUID);
                        },
                    ),
                    vulnerabilityQualification: getSelectableCell(
                        vulnerabilityQual,
                        [1, 2, 3, 4, 5],
                        (newValue: StringIndexedObject) => {
                            request({
                                url: "http://localhost:5000/risk-management-update",
                                method: "POST",
                                postData: { uuid: assetKey, vulnerability_qualif: newValue },
                            });
                            updateCellValue(assetKey, "vulnerabilityQualification", newValue, "vulnerability_qualif", risk["measures"], currentTreatmentUUID);
                        },
                    ),

                    currentRiskC: risk["c"] * threatProb * vulnerabilityQual,
                    currentRiskI: risk["i"] * threatProb * vulnerabilityQual,
                    currentRiskA: risk["a"] * threatProb * vulnerabilityQual,

                    treatmentLabel: getSelectableCell(currentTreatment, treatments, (value) => {
                        Object.keys(risk["measures"]).forEach((measureUUID: string) => {
                            if (String(value) === "") {
                                measureUUID = "";
                            }
                            if (String(value) === "" || risk["measures"][measureUUID]["name"] === value) {
                                request({
                                    url: "http://localhost:5000/risk-management-update",
                                    method: "POST",
                                    postData: { uuid: assetKey, treatment: measureUUID },
                                });
                                updateCellValue(assetKey, "currentTreatmentUUID", measureUUID, "uuid", risk["measures"], null);
                            }
                        });
                    }),
                    treatmentEffectiveness: getSelectableCell(
                        currentTreatmentEffectiveness,
                        [1, 2, 3, 4, 5],
                        (newValue: StringIndexedObject) => {
                            if (currentTreatmentUUID !== "") {
                                request({
                                    url: "http://localhost:5000/risk-management-update",
                                    method: "POST",
                                    postData: {uuid: assetKey, effectiveness: newValue},
                                });
                                updateCellValue(assetKey, currentTreatmentUUID, newValue, "treatmentEffectiveness", risk["measures"], currentTreatmentUUID);
                                updateCellValue(assetKey, "currentTreatmentUUID", currentTreatmentUUID, "uuid", risk["measures"], null);

                            }
                        },
                    ),
                    riskAfterTreatmentC: Math.max(
                        0,
                        risk["c"] * threatProb * vulnerabilityQual - currentTreatmentEffectiveness
                    ),
                    riskAfterTreatmentI: Math.max(
                        0,
                        risk["i"] * threatProb * vulnerabilityQual - currentTreatmentEffectiveness
                    ),
                    riskAfterTreatmentA: Math.max(
                        0,
                        risk["a"] * threatProb * vulnerabilityQual - currentTreatmentEffectiveness
                    ),
                });
            });
        });
        setTableData(mappedRiskManagement);
    }, [deviceData, deviceId, updateCellValue]);

    return <Table columns={riskManagementColumns} dataSource={tableData} tableLayout="fixed" bordered />;
}

    export default RiskManagementTable;