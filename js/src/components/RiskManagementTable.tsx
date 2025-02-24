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
                width: "2%",
            },
            {
                title: "I",
                dataIndex: "impactI",
                width: "2%",
            },
            {
                title: "A",
                dataIndex: "impactA",
                width: "2%",
            },
        ],
    },
    {
        title: "Threat",
        children: [
            {
                title: "Label",
                dataIndex: "threatName",
            },
            {
                title: "Prob.",
                dataIndex: "threatProbability",
            },
        ],
    },
    {
        title: "Vulnerability",
        children: [
            {
                title: "Label",
                dataIndex: "vulnerabilityName",
            },
            {
                title: "Qualif.",
                dataIndex: "vulnerabilityQualification",
            },
        ],
    },
    {
        title: "Current risk",
        children: [
            {
                title: "C",
                dataIndex: "currentRiskC",
                width: "2%",
            },
            {
                title: "I",
                dataIndex: "currentRiskI",
                width: "2%",
            },
            {
                title: "A",
                dataIndex: "currentRiskA",
                width: "2%",
            },
        ],
    },
    {
        title: "Treatment",
        children: [
            {
                title: "Label",
                dataIndex: "treatmentLabel",
                width: "10%",
            },
            {
                title: "Effect.",
                dataIndex: "treatmentEffectiveness",
            },
        ],
    },
    {
        title: "Risk after treatment",
        children: [
            {
                title: "C",
                dataIndex: "riskAfterTreatmentC",
                width: "2%",
            },
            {
                title: "I",
                dataIndex: "riskAfterTreatmentI",
                width: "2%",
            },
            {
                title: "A",
                dataIndex: "riskAfterTreatmentA",
                width: "2%",
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
        ></Select>
    );
}

interface InterfaceRiskManagementTable {
    deviceData: StringIndexedObject;
    deviceId: string;
}

const RiskManagementTable: React.FC<InterfaceRiskManagementTable> = ({ deviceData, deviceId }) => {
    const [tableData, setTableData] = useState<object[]>([]);

    const updateCellValue = useCallback((rowKey: string, field: string, newValue: StringIndexedObject | string, keyToUpdate: string, values: object, currentUUID: string) => {
        setTableData((prevData: any[]) =>
            prevData.map((row) => {
                if (row.key === rowKey) {
                    const updatedRow = { ...row };
                    if (currentUUID) {
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
                        updatedRow["treatmentEffectiveness"] = getSelectableCell(
                            newValue === "" ? 1 : updatedRow["treatments"][String(newValue)]["effectiveness"],
                            [1, 2, 3, 4, 5],
                            (newEffectiveness: StringIndexedObject) => {
                                if (String(newValue) !== "") {
                                    request({
                                        url: "http://localhost:5000/risk-management-update",
                                        method: "POST",
                                        postData: {uuid: newValue, effectiveness: newEffectiveness},
                                    });
                                    //updateTreatmentData(rowKey, String(newValue), Number(newEffectiveness));
                                    updateCellValue(rowKey, String(newValue), newEffectiveness, "treatmentEffectiveness", [], "");
                                    updatedRow["treatments"][String(newValue)]["effectiveness"] = newEffectiveness;
                                    updateCellValue(rowKey, "currentTreatmentUUID", newValue, "uuid", [], "");
                                }
                                //updateCellValue(assetKey, "vulnerabilityQualification", newValue, "vulnerability_qualif");
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
                                updateCellValue(rowKey, field, updatedValue, keyToUpdate, [], "");
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

                    updatedRow.riskAfterTreatmentC =
                        updatedRow["treatments"][updatedRow["currentTreatmentUUID"]]["effectiveness"] *
                        updatedRow.currentRiskC
                    updatedRow.riskAfterTreatmentI =
                        updatedRow["treatments"][updatedRow["currentTreatmentUUID"]]["effectiveness"] *
                        updatedRow.currentRiskI
                    updatedRow.riskAfterTreatmentA =
                        updatedRow["treatments"][updatedRow["currentTreatmentUUID"]]["effectiveness"] *
                        updatedRow.currentRiskA

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
                                //console.log("Measure Effectiveness:", risk["measures"][measureUUID]["effectiveness"]);
                                request({
                                    url: "http://localhost:5000/risk-management-update",
                                    method: "POST",
                                    postData: { uuid: assetKey, treatment: measureUUID },
                                });
                                updateCellValue(assetKey, "currentTreatmentUUID", measureUUID, "uuid", risk["measures"], "");
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
                                updateCellValue(assetKey, "currentTreatmentUUID", currentTreatmentUUID, "uuid", risk["measures"], currentTreatmentUUID);

                            }
                        },
                    ),
                    riskAfterTreatmentC: risk["c"] * threatProb * vulnerabilityQual * currentTreatmentEffectiveness,
                    riskAfterTreatmentI: risk["i"] * threatProb * vulnerabilityQual * currentTreatmentEffectiveness,
                    riskAfterTreatmentA: risk["a"] * threatProb * vulnerabilityQual * currentTreatmentEffectiveness,
                });
            });
        });
        setTableData(mappedRiskManagement);
    }, [deviceData, deviceId, updateCellValue]);

    return <Table columns={riskManagementColumns} dataSource={tableData} bordered />;
}

    export default RiskManagementTable;