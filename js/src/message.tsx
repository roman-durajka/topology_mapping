import { message } from "antd";

export const messageLoading = (
  messageApi: typeof message,
  messageString?: string,
) => {
  messageApi.open({
    type: "loading",
    content: messageString ? messageString : "Action in progress..",
    duration: 0,
  });
};

export const messageError = (
  messageApi: typeof message,
  messageString?: string,
) => {
  messageApi.open({
    type: "error",
    content: messageString
      ? messageString
      : "Error occurred while processing the request.",
  });
};

export const messageSuccess = (
  messageApi: typeof message,
  messageString?: string,
) => {
  messageApi.open({
    type: "success",
    content: messageString
      ? messageString
      : "Request was successfuly processed.",
  });
};
