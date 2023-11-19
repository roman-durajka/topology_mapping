"use client";
import React, { useState, useEffect } from "react";
import axios from "axios";
import "./styles.css";

function RenderApplicationGroups() {
  const [applicationGroups, setApplicationGroups] = useState([]);

  useEffect(() => {
    axios
      .get("http://localhost:5000/application-groups")
      .then((response) => {
        setApplicationGroups(response.data.data);
      })
      .catch((error) => {
        console.error("API request error:", error);
      });
  }, []);

  const [editableGroups, setEditableGroups] = useState({});
  const [makeRequest, setMakeRequest] = useState(false);

  //save data to database
  useEffect(() => {
    if (makeRequest) {
      console.log(JSON.stringify(editableGroups));
      axios
        .post(
          "http://localhost:5000/update-application-groups",
          JSON.stringify(editableGroups),
          {
            headers: {
              "Content-Type": "application/json",
            },
          },
        )
        .catch((error) => {
          console.error("API request error:", error);
        })
        .finally(() => {
          setMakeRequest(false);
        });
    }
  }, [makeRequest]);

  const handleEditClick = (groupId) => {
    setEditableGroups((prevEditableGroups) => ({
      ...prevEditableGroups,
      [groupId]: {
        ...prevEditableGroups[groupId],
        ["state"]: true,
      },
    }));
  };

  const handleSaveClick = (groupId) => {
    console.log("Edited Data for Group", groupId, ":", editableGroups[groupId]);

    const fields = ["business_process_name", "information_systems"];
    let valid = false;

    //TODO: better checking for empty strings and lists
    fields.forEach((field) => {
      if (
        editableGroups[groupId][field] &&
        editableGroups[groupId][field].length > 0
      ) {
        if (!valid) valid = true;
        //set new values to applicationGroups, so it is also displayed in gui
        setApplicationGroups((prevApplicationGroups) => ({
          ...prevApplicationGroups,
          [groupId]: {
            ...prevApplicationGroups[groupId],
            [field]: editableGroups[groupId][field],
          },
        }));
      }
    });

    if (valid) {
      console.log(JSON.stringify(editableGroups));
      setMakeRequest(true);
    }

    setEditableGroups((prevEditableGroups) => ({
      ...prevEditableGroups,
      [groupId]: {
        ...prevEditableGroups[groupId],
        ["state"]: false,
      },
    }));
  };

  const handleInputChange = (groupId, field, value) => {
    setEditableGroups((prevEditableGroups) => ({
      ...prevEditableGroups,
      [groupId]: {
        ...prevEditableGroups[groupId],
        [field]: value,
      },
    }));
  };

  return (
    <div className="application-groups">
      {applicationGroups &&
        Object.keys(applicationGroups).map((key) => {
          const group = applicationGroups[key];

          const groupId = key;
          const isEditable = editableGroups[groupId]
            ? editableGroups[groupId]["state"]
            : false;

          return (
            <div key={key} className="application-group-box">
              <div className="application-group-header">
                <div className="application-group-header-group1">
                  <div key={key} className="application-group">
                    <div>Business Process:&#32;</div>
                    <div className="application-group-text">
                      {isEditable ? (
                        <input
                          className="application-group-input"
                          type="text"
                          value={
                            editableGroups[groupId].business_process_name ||
                            group.business_process_name
                          }
                          onChange={(e) =>
                            handleInputChange(
                              groupId,
                              "business_process_name",
                              e.target.value,
                            )
                          }
                        />
                      ) : (
                        group.business_process_name
                      )}
                    </div>
                  </div>
                  <div key={key} className="application-group">
                    <div>Information Systems:</div>
                    <div className="application-group-text">
                      {isEditable ? (
                        <input
                          className="application-group-input"
                          type="text"
                          value={
                            (
                              editableGroups[groupId]?.information_systems || []
                            ).join(",") || group.information_systems.join(",")
                          }
                          onChange={(e) =>
                            handleInputChange(
                              groupId,
                              "information_systems",
                              e.target.value
                                .split(",")
                                .map((value) => value.trim()),
                            )
                          }
                        />
                      ) : (
                        group.information_systems.join(",")
                      )}
                    </div>
                  </div>
                </div>
                <div className="application-group-buttons">
                  <div className="application-group-redirect">
                    <span>&#8594;</span>{" "}
                  </div>
                  {isEditable ? (
                    <div
                      className="application-group-edit"
                      onClick={() => handleSaveClick(groupId)}
                    >
                      Save
                    </div>
                  ) : (
                    <div
                      className="application-group-edit"
                      onClick={() => handleEditClick(groupId)}
                    >
                      Edit
                    </div>
                  )}
                </div>
              </div>
              <div key={key} className="application-group-split"></div>
              <div key={key} className="application-group-devices-content">
                <div className="application-group-devices-title">Devices</div>
                <div className="application-group-devices">
                  {Object.keys(group.devices).map((device_id) => (
                    <div className="application-group-device" key={device_id}>
                      &#x2022; {group["devices"][device_id]}
                    </div>
                  ))}
                </div>
              </div>
            </div>
          );
        })}
    </div>
  );
}

function ApplicationGroups() {
  return <RenderApplicationGroups />;
}

export default ApplicationGroups;
