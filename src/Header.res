@react.component
let make = () => {
  let (_state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  <Appbar.Header>
    <Appbar.Action icon=Icon.name("home") onPress={_ => dispatch(Navigate(Home_Elections))} />
    <Appbar.Content title={"Verifiable secret voting" -> React.string} />
    //<Appbar.Action icon=Icon.name("cog-outline") onPress={_ => dispatch(Navigate(Route.User_Profile))}></Appbar.Action>
  </Appbar.Header>
}
