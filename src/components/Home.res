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
      </Title>
      <Button mode=#contained onPress={_ => dispatch(Navigate(Route.ElectionNew))} style=X.styles["margin-x"]>
        {"Creer une nouvelle election" -> React.string}
      </Button>
      <View style=X.styles["separator"] />
      <Home_ElectionList />
    </>
  }
}