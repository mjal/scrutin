open ReactNative
open! Paper

@react.component
let make = () => {
  let (token, setToken) = React.useState(_ => "")
  let (state, dispatch) = Context.use()

  <>
    <Title style=X.styles["center"]> { "Check your emails and enter your token" -> React.string } </Title>

    <TextInput
      mode=#flat
      label="Token"
      testID="token-input"
      value=token
      onChangeText={text => setToken(_ => text)}
    />

    <Button mode=#contained onPress={_ => ()}>
      { "Se connecter" -> React.string }
    </Button>
  </>
}