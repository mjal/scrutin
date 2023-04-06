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
  open Style

  StyleSheet.create({
    "title": textStyle(
      ~textAlign=#center,
      ~fontSize=20.0,
      ~color=Color.black,
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
    ),

    "margin-x": viewStyle(
      ~marginLeft=15.0->dp,
      ~marginRight=15.0->dp,
      ()
    ),

    "pad-left": viewStyle(
      ~marginLeft=40.0->dp,
      ()
    ),

    "margin-y-8": viewStyle(
      ~marginTop=8.0->dp,
      ~marginBottom=8.0->dp,
      ()
    ),

    "modal": textStyle(
      ~padding=10.0->dp,
      ~margin=10.0->dp,
      ~backgroundColor=Color.white,
      ()
    ),
    "layout": {
      if ReactNative.Platform.os == #web && Dimension.width() > 800 {
        viewStyle(
          ~width=800.0->dp,
          ~alignSelf=#center,
          ()
        )
      } else { viewStyle() }
    },
    "center": viewStyle(~alignSelf=#center, ()),

    "green": textStyle(~color=Color.green, ()),
    "red": textStyle(~color=Color.red, ()),
  })
}

module Row = {
  @react.component
  let make = (~children) => {
    <ReactNative.View style=styles["row"]>
      {children}
    </ReactNative.View>
  }
}

module Col = {
  @react.component
  let make = (~children) => {
    <ReactNative.View style=styles["col"]>
      {children}
    </ReactNative.View>
  }
}

module SegmentedButtons = {
  type button = {
    value: string,
    label: string
  }
  @module("react-native-paper") @react.component
  external make: (
    ~value: string,
    ~onValueChange: (string) => (),
    ~buttons: array<button>,
    ~theme: Paper__ThemeProvider.Theme.t=?,
    ~style: ReactNative.Style.t=?,
    // density
  ) => React.element = "SegmentedButtons"
}

module Title = {
  @react.component
  let make = (~children) => {
    <Title style=styles["title"]>
      {children}
    </Title>
  }
}

// Forms
let ev = (event) => ReactEvent.Form.target(event)["value"] 
let prevent = (f) =>
  (e) => {
    ReactEvent.Synthetic.preventDefault(e)
    f(e)
  }
let isKeyEnter : ('a => bool) = %raw(`function(key) { return key.key == "Enter" }`)

@val external nodeEnv: string = "process.env.NODE_ENV"

let env = switch nodeEnv {
| "production" => #prod
| "development" => #dev
| _ => #dev
}

let env = #prod
