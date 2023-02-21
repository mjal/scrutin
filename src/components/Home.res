open ReactNative
open! Paper
include Paper

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  let (email, setEmail) = React.useState(_ => "")
  let (loading, setLoading) = React.useState(_ => false)

  switch state.user {
  | None =>
    dispatch(Navigate(User_Register))
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