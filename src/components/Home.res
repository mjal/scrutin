open ReactNative
open! Paper

@react.component
let make = () => {
  let (_, dispatch) = State.useContextReducer()

  let _theme = ThemeProvider.useTheme()

  //<View style=ThemeProvider.Theme.colors>
  <View>
    <View style=X.styles["separator"] />
    <Button mode=#contained onPress={_ => dispatch(Navigate(Route.ElectionNew))}>
      {"Creer une nouvelle election" -> React.string}
    </Button>
    <View style=X.styles["separator"] />
    <Home_ElectionList />
  </View>
}