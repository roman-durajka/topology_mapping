import { Dispatch } from "react";

interface RequesterProps {
  setState: Dispatch<object>;
  url: string;
  method: string;
  postData?: object;
}

function request({ setState, url, method, postData }: RequesterProps) {
  let requestOptions: RequestInit = {
    method: method,
    headers: { "Content-Type": "application/json" },
  };

  if (method === "POST" && postData) {
    requestOptions = {
      ...requestOptions,
      body: JSON.stringify(postData),
    };
  }

  fetch(url, requestOptions)
    .then((response) => response.json())
    .then((data) => {
      setState(data);
    });
}

export default request;
