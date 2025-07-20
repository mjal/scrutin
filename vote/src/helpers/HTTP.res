let post = (url, json) => {
  let headers = {
    "Content-Type": "application/json",
  }->Webapi.Fetch.HeadersInit.make

  let body = json->Js.Json.stringify->Webapi.Fetch.BodyInit.make

  Webapi.Fetch.fetchWithInit(url, Webapi.Fetch.RequestInit.make(~method_=Post, ~body, ~headers, ()))
}

// TODO: Refactor with post
let put = (url, json) => {
  let headers = {
    "Content-Type": "application/json",
  }->Webapi.Fetch.HeadersInit.make

  let body = json->Js.Json.stringify->Webapi.Fetch.BodyInit.make

  Webapi.Fetch.fetchWithInit(url, Webapi.Fetch.RequestInit.make(~method_=Put, ~body, ~headers, ()))
}
