@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  <>
    <X.Title>{ "Identités" -> React.string }</X.Title>
    <List.Section title="" style=X.styles["margin-x"]>
      <></>
    </List.Section>
    <Button mode=#outlined onPress={ _ => dispatch(Action.Identity_Generate) }>
      { "Create a new identity" -> React.string }
    </Button>

    <X.Title>{ "Transactions" -> React.string }</X.Title>
    <List.Section title="" style=X.styles["margin-x"]>
      <></>
    </List.Section>

    <X.Title>{ "Elections" -> React.string }</X.Title>

    <X.Title>{ "Ballots"   -> React.string }</X.Title>

    <X.Title>{ "Trustees"  -> React.string }</X.Title>
  </>

  /*
  React.useEffect0(_ => {
    if Option.isNone(state.user) {
      dispatch(Action.Navigate(Route.User_Register))
    }
    None
  })

  Js.log(state.user)

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
  */
}
