@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  React.useEffect0(_ => {
    if Option.isNone(state.user) {
      dispatch(Action.Navigate(Route.User_Register))
    }
    None
  })

  switch state.user {
  | None =>
    "Redirecting..." -> React.string
  | Some(_user) =>
    <>
      <Button mode=#contained onPress={_ => dispatch(Navigate(Route.ElectionNew))} style=X.styles["margin-x"]>
        {"Creer une nouvelle election" -> React.string}
      </Button>
      <ElectionList title="Elections en cours" elections=state.elections loading=state.elections_loading />
    </>
  }
}