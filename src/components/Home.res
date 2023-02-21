open! Paper

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  switch state.user {
  | None =>
    <>
      <Button>
        {"Signup" -> React.string}
      </Button>
      <Button>
        {"Signin" -> React.string}
      </Button>
    </>
  | Some(_user) =>
    <>
      <Button mode=#contained onPress={_ => dispatch(Navigate(Route.ElectionNew))} style=X.styles["margin-x"]>
        {"Creer une nouvelle election" -> React.string}
      </Button>
      <ElectionList title="Elections en cours" elections=state.elections loading=state.elections_loading />
    </>
  }
}