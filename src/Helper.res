let bind = Belt.Option.flatMap
let css  = ReactDOMStyle.make

let rs = React.string
//let texts = Mui.TextField.Value.string
//let boxs = Mui.Box.Value.string

let ra = React.array

// Forms
let ev = (event) => ReactEvent.Form.target(event)["value"] 
let prevent = (f) =>
  (e) => {
    ReactEvent.Synthetic.preventDefault(e)
    f(e)
  }

let post = (url, json) => {
  let headers = {
    "Content-Type": "application/json"
  }
  -> Webapi.Fetch.HeadersInit.make

  let body = json
  -> Js.Json.stringify
  -> Webapi.Fetch.BodyInit.make

  Webapi.Fetch.fetchWithInit(
    url,
    Webapi.Fetch.RequestInit.make(~method_=Post, ~body, ~headers, ()),
  )
}
