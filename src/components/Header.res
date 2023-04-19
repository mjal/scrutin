@react.component
let make = (~title="", ~subtitle="",
  ~titleTextStyle=?,
  ~subtitleTextStyle=?
) => {
  let (state, dispatch) = StateContext.use()

  let titleTextStyle = StyleSheet.flatten([
    Style.textStyle(
      ~alignSelf=#center,
      ~fontWeight=Style.FontWeight._900,
      ~marginTop=30.0->Style.dp,
      ~fontSize=25.0,
      ~lineHeight=24.0,
      ~color=S.primaryColor,
      ()),
    Option.getWithDefault(titleTextStyle, Style.textStyle())
  ])

  let subtitleTextStyle = StyleSheet.flatten([
    Style.textStyle(
      ~alignSelf=#center,
      ~fontSize=22.0,
      ~color=S.primaryColor,
      ()),
    Option.getWithDefault(subtitleTextStyle, Style.textStyle())
  ])


  let backButton = switch state.route {
  | list{} | list{""} => <></>
  | _ =>
    <TouchableOpacity
      style=Style.viewStyle(
        ~marginTop=40.0->Style.dp,
        ~marginLeft=40.0->Style.dp,
        ())
      onPress={_ => dispatch(StateMsg.Navigate_Back)}>
      <BackButton />
    </TouchableOpacity>
  }

  let settingsButton = switch state.route {
  | list{} | list{""} => <Appbar.Action
    icon=Icon.name("cog-outline")
    onPress={_ => dispatch(Navigate(list{"settings"}))} />
  | _ => <></>
  }

  <Appbar.Header style=Style.viewStyle(
    ~backgroundColor=Color.white,
    ~marginBottom=20.0->Style.dp,
    ())>
    { backButton }
    <Appbar.Content title={
      <>
        <Title style=titleTextStyle>
          { title -> React.string }
        </Title>
        <Text style=subtitleTextStyle>
          { subtitle -> React.string }
        </Text>
      </>
    } />
    { settingsButton }
  </Appbar.Header>
}
