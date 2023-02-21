open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  <View>
    <Button mode=#contained onPress={_ => ()} style=X.styles["margin-x"]>
      { "Signin" -> React.string }
    </Button>
  </View>
}