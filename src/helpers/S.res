open Style

let title = textStyle(
  ~textAlign=#center,
  ~fontSize=20.0,
  ~color=Color.black,
  ()
)

module Title = {
  @react.component
  let make = (~children) => {
    <Title style=title>
      { children }
    </Title>
  }
}

module Row = {
  @react.component
  let make = (~children) => {
    let style = viewStyle(
      ~flexDirection=#row,
      ~padding=10.0->dp,
      ()
    )
    <ReactNative.View style>
      {children}
    </ReactNative.View>
  }
}

module Col = {
  @react.component
  let make = (~children) => {
    let style = viewStyle(
      ~flex=1.0,
      ~padding=5.0->dp,
      ()
    )
    <ReactNative.View style>
      {children}
    </ReactNative.View>
  }
}

let marginX = viewStyle(
  ~marginLeft=15.0->dp,
  ~marginRight=15.0->dp,
  ()
)
