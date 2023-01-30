open ReactNative
open! Paper

@react.component
let make = () => {
  let (_, dispatch) = State.useContexts()

  let _theme = ThemeProvider.useTheme()

  //<View style=ThemeProvider.Theme.colors>
  <View>
    <View style=X.styles["separator"] />
    <Button mode=#contained onPress={_ => dispatch(Navigate(Route.ElectionNew))} style=X.styles["margin-x"]>
      {"Creer une nouvelle election" -> React.string}
    </Button>
    <View style=X.styles["separator"] />
    <Home_ElectionList />
  </View>
}