let post = (url, json) => {
  let headers = {
    "Content-Type": "application/json",
  }->Webapi.Fetch.HeadersInit.make

  let body = json->Js.Json.stringify->Webapi.Fetch.BodyInit.make

  Webapi.Fetch.fetchWithInit(url, Webapi.Fetch.RequestInit.make(~method_=Post, ~body, ~headers, ()))
}

// Forms
let ev = event => ReactEvent.Form.target(event)["value"]
let prevent = (f, e) => {
  ReactEvent.Synthetic.preventDefault(e)
  f(e)
}
let isKeyEnter: 'a => bool = %raw(`function(key) { return key.key == "Enter" }`)

@val external nodeEnv: string = "process.env.NODE_ENV"

let env = switch nodeEnv {
| "production" => #prod
| "development" => #dev
| _ => #dev
}
