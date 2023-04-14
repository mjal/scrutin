@react.component
let make = (~title="", ~subtitle="") => {
  let (state, dispatch) = Context.use()

  let titleTextStyle = Style.textStyle(
    ~alignSelf=#center,
    ~fontWeight=Style.FontWeight._900,
    ~fontSize=25.0,
    ~lineHeight=24.0,
    ~color=Color.rgb(~r=103, ~g=80, ~b=164),
    ()
  )

  let backButton = switch state.route {
  | list{} | list{""} => <></>
  | _ => <Appbar.Action
      icon=Icon.name("arrow-left")
      onPress={_ => dispatch(Navigate(list{}))} />
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
        <Text style=titleTextStyle>
          { subtitle -> React.string }
        </Text>
      </>
    } />
    { settingsButton }
  </Appbar.Header>
}
