open Style

let primaryColor = switch X.env {
| #dev => Color.rgb(~r=255, ~g=128, ~b=128)
| #prod => Color.rgb(~r=103, ~g=80, ~b=164)
}

let flatten = StyleSheet.flatten

let title = textStyle(
  ~fontFamily="Inter_400Regular",
  ~textAlign=#center, ~fontSize=20.0, ~color=Color.black, ())

let headerTitle = switch ReactNative.Platform.os {
| #web =>
  textStyle(
    ~alignSelf=#center,
    ~fontFamily="Inter_700Bold",
    ~fontWeight=FontWeight._900,
    ~marginTop=45.0->dp,
    ~fontSize=28.0,
    ~lineHeight=24.0,
    ~color=primaryColor,
    ())
| _ =>
  textStyle(
    ~alignSelf=#center,
    ~fontFamily="Inter_700Bold",
    ~fontWeight=FontWeight._300,
    ~marginTop=20.0->dp,
    ~fontSize=20.0,
    ~color=primaryColor,
    ())
}


let marginX = viewStyle(~marginLeft=15.0->dp, ~marginRight=15.0->dp, ())

let marginY = size => {
  viewStyle(~marginTop=size->dp, ~marginBottom=size->dp, ())
}

let widthPct = size => {
  viewStyle(~width=size->pct, ())
}

let modal = textStyle(~padding=10.0->dp, ~margin=10.0->dp, ~backgroundColor=Color.white, ())

let section = textStyle(
  ~fontFamily="Inter_400Regular",
  ~fontSize=20.0,
  ~marginTop=15.0->dp,
  ~marginBottom=15.0->dp,
  ~marginLeft=60.0->dp,
  (),
)

let layout = if ReactNative.Platform.os == #web && Dimension.width() > 800 {
  viewStyle(
    ~width=800.0->dp,
    ~alignSelf=#center,
    (),
  )
} else {
  viewStyle()
}

let questionBox = viewStyle(~margin=30.0->dp, ~borderWidth=5.0, ~borderColor=primaryColor, ())

module Section = {
  @react.component
  let make = (~title) => {
    <Title style=section> {title->React.string} </Title>
  }
}

module Title = {
  @react.component
  let make = (~children) => {
    <Title style=title> {children} </Title>
  }
}

module Row = {
  @react.component
  let make = (~children, ~style=?) => {
    let style = StyleSheet.flatten([
      viewStyle(~flexDirection=#row, ~padding=10.0->dp, ()),
      Option.getWithDefault(style, viewStyle()),
    ])
    <View style> {children} </View>
  }
}

module Col = {
  @react.component
  let make = (~children, ~style=?) => {
    let style = StyleSheet.flatten([
      viewStyle(~flex=1.0, ~padding=5.0->dp, ()),
      Option.getWithDefault(style, viewStyle()),
    ])
    <View style> {children} </View>
  }
}

module SegmentedButtons = {
  type button = {
    value: string,
    label: string,
  }
  @module("react-native-paper") @react.component
  external make: (
    ~value: string,
    ~onValueChange: string => unit,
    ~buttons: array<button>,
    ~theme: Paper__ThemeProvider.Theme.t=?,
    ~style: ReactNative.Style.t=?,
  ) => // density
  React.element = "SegmentedButtons"
}

module Button = {
  @react.component
  let make = (~onPress, ~title, ~style=?, ~titleStyle=?, ~testID=?) => {
    let defaultStyle = viewStyle(
      ~alignSelf=#center,
      ~width=300.0->dp,
      ~marginTop=25.0->dp,
      ~paddingVertical=5.0->dp,
      ~borderRadius=0.0,
      (),
    )

    let defaultTitleStyle = textStyle(
      ~fontFamily="Inter_400Regular",
      ~fontSize=20.0, ~color=Color.white, ())

    let style = switch style {
    | Some(style) => StyleSheet.flatten([defaultStyle, style])
    | None => defaultStyle
    }

    let titleStyle = switch titleStyle {
    | Some(titleStyle) => StyleSheet.flatten([defaultTitleStyle, titleStyle])
    | None => defaultTitleStyle
    }

    <Button mode=#contained style onPress>
      <Text style=titleStyle ?testID> {title->React.string} </Text>
    </Button>
  }
}

module TextInput = {
  @react.component
  let make = (~label=?, ~testID=?, ~value,
    ~onChangeText, ~placeholder=?) => {
    let style = viewStyle(
      ~marginHorizontal=25.0->dp,
      ~backgroundColor=Color.white,
      ~borderWidth=1.0,
      ~shadowRadius=2.0,
      (),
    )

    <TextInput style mode=#flat ?label ?testID ?placeholder
    value onChangeText />
  }
}
