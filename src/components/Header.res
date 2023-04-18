@react.component
let make = (~title="", ~subtitle="",
  ~titleTextStyle=?,
  ~subtitleTextStyle=?
) => {
  let (state, dispatch) = Context.use()

  let titleTextStyle = StyleSheet.flatten([
    Style.textStyle(
      ~alignSelf=#center,
      ~fontWeight=Style.FontWeight._900,
      ~fontSize=25.0,
      ~lineHeight=24.0,
      ~color=Color.rgb(~r=103, ~g=80, ~b=164),
      ()),
    Option.getWithDefault(titleTextStyle, Style.textStyle())
  ])

  let subtitleTextStyle = StyleSheet.flatten([
    Style.textStyle(
      ~alignSelf=#center,
      ~fontWeight=Style.FontWeight._600,
      ~fontSize=22.0,
      ~lineHeight=20.0,
      ~color=Color.rgb(~r=103, ~g=80, ~b=164),
      ()),
    Option.getWithDefault(subtitleTextStyle, Style.textStyle())
  ])


  let backButton = switch state.route {
  | list{} | list{""} => <></>
  | _ => <Appbar.Action
      icon=Icon.name("arrow-left")
      onPress={_ => dispatch(StateMsg.Navigate_Back)} />
  }

  let settingsButton = switch state.route {
  | list{} | list{""} => <Appbar.Action
    icon=Icon.name("cog-outline")
    onPress={_ => dispatch(Navigate(list{"settings"}))} />
  | _ => <></>
  }

  <Appbar.Header style=Style.viewStyle(~backgroundColor=Color.white,())>
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
