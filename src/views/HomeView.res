open ReactNative
open! Paper

@react.component
let make = () => {
  let (_, dispatch) = State.useContextReducer()

  <View>
    <View style=X.styles["separator"] />
    <Button mode=#contained onPress={_ => dispatch(Navigate(Route.ElectionNew))}>
      {"Creer une nouvelle election" -> React.string}
    </Button>
    <View style=X.styles["separator"] />
    <Title>
      <Text>{"Mes elections" -> React.string}</Text>
    </Title>
    <View style=X.styles["separator"] />
    <ElectionList />
  </View>
}