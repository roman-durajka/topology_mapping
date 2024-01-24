import { Dispatch } from "react";

interface RequesterProps {
  url: string;
  method: string;
  postData?: object;
}

function request({ url, method, postData }: RequesterProps) {
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

  return fetch(url, requestOptions);
  //.then((response) => response.json())
  //.then((data) => {
  //return data;
  //if (setState) {
  //  setState(data);
  //}
}

export default request;
