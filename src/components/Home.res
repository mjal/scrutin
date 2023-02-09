open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  switch state.user {
  | None => <Login />
  | Some(user) =>
    <>
      <Title style=X.styles["title"]>
        { `Hello ${user.email}` -> React.string }
        <Button mode=#contained onPress={_ => dispatch(Navigate(Route.Profile))} style=X.styles["margin-x"]>
          {"Go to profile" -> React.string}
        </Button>
        <Button mode=#contained onPress={_ => dispatch(User_Logout)} style=X.styles["margin-x"]>
          <Text>{ "Logout" -> React.string }</Text>
        </Button>
      </Title>
      <Button mode=#contained onPress={_ => dispatch(Navigate(Route.ElectionNew))} style=X.styles["margin-x"]>
        {"Creer une nouvelle election" -> React.string}
      </Button>
      <View style=X.styles["separator"] />
      <ElectionList title="Elections en cours" elections=state.elections loading=state.elections_loading />
    </>
  }
}