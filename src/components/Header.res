@react.component
let make = () => {
  let (_state, dispatch) = Context.use()

  <Appbar.Header>
    <Appbar.Action icon=Icon.name("home") onPress={_ => dispatch(Navigate(Home_Elections))} />
    <Appbar.Content title={"Verifiable secret voting" -> React.string} />
    <Appbar.Action icon=Icon.name("cog-outline") onPress={_ => dispatch(Navigate(Route.Settings))}></Appbar.Action>
  </Appbar.Header>
}
