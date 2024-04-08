import { TopologyConnector } from "../TopologyConnector";
import request from "../components/Requester";
import { messageError, messageSuccess } from "../components/message";
import { MessageInstance } from "antd/es/message/interface";

const addDeviceFormSubmit = (
  data: { [key: string]: any },
  connector: TopologyConnector,
  messageApi: MessageInstance,
) => {
  const formData = {
    ...data,
    icon: data.type,
    "asset-value": 0,
    "asset-values": [0],
    id: connector.getNodeStartingIndex(),
  };
  const responseData: Promise<Response> = request({
    url: "http://localhost:5000/add-device",
    method: "POST",
    postData: formData,
  });

  responseData
    .then((response) => response.json())
    .then((data) => {
      //add device to topology
      connector.addDevice(formData);
      //make alert
      if (data.code === 200) {
        messageSuccess(messageApi, "Device was successfully added.");
      } else {
        messageError(messageApi, `Could not add device: ${data.error}`);
      }
      console.log(formData);
    });
};

export { addDeviceFormSubmit };
