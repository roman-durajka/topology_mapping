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

    const updateCellValue = useCallback((rowKey: string, field: string, newValue: StringIndexedObject, keyToUpdate: string) => {
        setTableData((prevData: any[]) =>
            prevData.map((row) => {
                if (row.key === rowKey) {
                    const updatedRow = { ...row };

                    updatedRow[field] = getSelectableCell(
                        newValue,
                        [1, 2, 3, 4, 5],
                        (updatedValue: StringIndexedObject) => {
                            request({
                                url: "http://localhost:5000/risk-management-update",
                                method: "POST",
                                postData: { uuid: rowKey, [keyToUpdate]: updatedValue },
                            });
                            updateCellValue(rowKey, field, updatedValue, keyToUpdate);}
                    );

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

                const treatments: any = Object.keys(risk["measures"]).map(
                    (measureUUID: string) => risk["measures"][measureUUID]["name"],
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
                            updateCellValue(assetKey, "impactC", newValue, "c");
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
                            updateCellValue(assetKey, "impactI", newValue, "i");
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
                            updateCellValue(assetKey, "impactA", newValue, "a");
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
                            updateCellValue(assetKey, "threatProbability", newValue, "threat_prob");
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
                            updateCellValue(assetKey, "vulnerabilityQualification", newValue, "vulnerability_qualif");
                        },
                    ),

                    currentRiskC: risk["c"] * threatProb * vulnerabilityQual,
                    currentRiskI: risk["i"] * threatProb * vulnerabilityQual,
                    currentRiskA: risk["a"] * threatProb * vulnerabilityQual,

                    treatmentLabel: getSelectableCell("", treatments, (value) => {
                        Object.keys(risk["measures"]).forEach((measureUUID: string) => {
                            if (risk["measures"][measureUUID]["name"] === value["label"]) {
                                console.log("Measure Effectiveness:", risk["measures"][measureUUID]["effectiveness"]);
                            }
                        });
                    }),
                    treatmentEffectiveness: 1,
                });
            });
        });
        setTableData(mappedRiskManagement);
    }, [deviceData, deviceId, updateCellValue]);

    return <Table columns={riskManagementColumns} dataSource={tableData} bordered />;
}

    export default RiskManagementTable;