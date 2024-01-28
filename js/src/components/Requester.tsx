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
}

export default request;
