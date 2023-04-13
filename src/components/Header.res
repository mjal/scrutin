@react.component
let make = () => {
  let (_state, dispatch) = Context.use()

  <Appbar.Header>
    <Appbar.Action icon=Icon.name("home") onPress={_ => dispatch(Navigate(list{}))} />
    <Appbar.Content title=<></> />
    <Appbar.Action icon=Icon.name("cog-outline") onPress={_ => dispatch(Navigate(list{"settings"}))}></Appbar.Action>
  </Appbar.Header>
}
