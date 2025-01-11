@react.component
let make = (~title="", ~subtitle="", ~titleTextStyle=?, ~subtitleTextStyle=?) => {
  let (state, dispatch) = StateContext.use()

  let titleTextStyle = StyleSheet.flatten([
    Style.textStyle(
      ~fontFamily="Inter_700Bold",
      ~color=Color.rgb(~r=0x3f, ~g=0x3f, ~b=0x3f),
      ~marginBottom=10.0->Style.dp,
      ()),
    switch ReactNative.Platform.os {
    | #web =>
      Style.textStyle(
        ~fontWeight=Style.FontWeight._900,
        ~marginTop=45.0->Style.dp,
        ~fontSize=28.0,
        ~lineHeight=24.0,
        ())
    | _ =>
      Style.textStyle(
        ~fontWeight=Style.FontWeight._300,
        ~marginTop=20.0->Style.dp,
        ~fontSize=20.0,
        ())
    },
    Option.getWithDefault(titleTextStyle, Style.textStyle()),
  ])

  let subtitleTextStyle = StyleSheet.flatten([
    Style.textStyle(~fontSize=22.0, ~color=Color.rgb(~r=0x90, ~g=0x90, ~b=0x90), ()),
    Option.getWithDefault(subtitleTextStyle, Style.textStyle()),
  ])

  //let backButton = switch state.route {
  //| list{} | list{""} => <> </>
  //| _ =>
  //  <TouchableOpacity
  //    style={Style.viewStyle(~marginTop=40.0->Style.dp, ~marginLeft=40.0->Style.dp, ())}
  //    onPress={_ => dispatch(StateMsg.Navigate_Back)}>
  //    <SIcon.ButtonBack />
  //  </TouchableOpacity>
  //}

  let settingsButton = switch state.route {
  | list{} | list{""} =>
    <Appbar.Action
      icon={Icon.name("cog-outline")} onPress={_ => dispatch(Navigate(list{"settings"}))}
    />
  | _ => <> </>
  }

  let backgroundColor = Color.rgb(~r=0xf4, ~g=0xf4, ~b=0xf4)

  <Appbar.Header
    style={Style.viewStyle(
      ~backgroundColor,
      ~marginBottom=40.0->Style.dp,
      ~marginLeft=15.0->Style.dp,
      ())}>
    //{backButton}
    <Appbar.Content
      title={<>
        <Title style=titleTextStyle> {title->React.string} </Title>
        <Text style=subtitleTextStyle> {subtitle->React.string} </Text>
      </>}
    />
    {settingsButton}
  </Appbar.Header>
}
