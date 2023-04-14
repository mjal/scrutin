open Style

let flatten = StyleSheet.flatten

let title = textStyle(
  ~textAlign=#center,
  ~fontSize=20.0,
  ~color=Color.black,
  ()
)

let marginX = viewStyle(
  ~marginLeft=15.0->dp,
  ~marginRight=15.0->dp,
  ()
)

let marginY = (size) => {
  viewStyle(
    ~marginTop=size->dp,
    ~marginBottom=size->dp,
    ()
  )
}

let modal = textStyle(
  ~padding=10.0->dp,
  ~margin=10.0->dp,
  ~backgroundColor=Color.white,
  ()
)

let layout =
  if ReactNative.Platform.os == #web && Dimension.width() > 800 {
    viewStyle(
      ~width=800.0->dp,
      ~alignSelf=#center,
      ~borderColor=Color.rgb(~r=103, ~g=80, ~b=164),
      ~borderWidth=3.0,
      ~borderRadius=40.0,
      ~height=100.0->pct,
      ()
    )
  } else { viewStyle() }

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

module Button = {
  @react.component
  let make = (~onPress, ~title,
    ~style=?, ~titleStyle=?
  ) => {
    let defaultStyle = viewStyle(
      ~alignSelf=#center,
      ~width=300.0->dp,
      ~marginTop=25.0->dp,
      ~borderRadius=0.0,
    ())

    let defaultTitleStyle = textStyle(
      ~fontSize=20.0,
      ~color=Color.white,
      ()
    )

    let style = switch style {
    | Some(style) => StyleSheet.flatten([defaultStyle, style])
    | None => defaultStyle
    }

    let titleStyle = switch titleStyle {
    | Some(titleStyle) => StyleSheet.flatten([defaultTitleStyle, titleStyle])
    | None => defaultTitleStyle
    }

    <Button mode=#contained style onPress>
      <Text style=titleStyle>
        { title -> React.string }
      </Text>
    </Button>
  }
}
