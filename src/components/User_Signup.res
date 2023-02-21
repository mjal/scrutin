open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  <View>
    <Button mode=#contained onPress={_ => ()}>
      { "Signup" -> React.string }
    </Button>
  </View>
}