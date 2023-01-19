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

let styles = {
  open ReactNative
  open Style

  StyleSheet.create({
    "title": textStyle(
      ~textAlign=#center,
      ~fontSize=20.0,
      ()
    ),
    "subtitle": textStyle(
      ~textAlign=#center,
      ()
    ),

    "separator": viewStyle(
      ~height=20.0->dp,
      ()
    ),

    "row": viewStyle(
      ~flexDirection=#row,
      ~padding=10.0->dp,
      ()
    ),
    "col": viewStyle(
      ~flex=1.0,
      ~padding=5.0->dp,
      ()
    ),

    "smallButton": textStyle(
      ~height=15.0->dp,
      ()
    )
  })
}