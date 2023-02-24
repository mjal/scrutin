open ReactNative
open! Paper

@react.component
let make = (~secret=None: option<string>) => {
  let (secret, setSecret) = React.useState(_ => secret)
  let (state, dispatch) = Context.use()

  let onSubmit = _ => {
      let data = {
        let dict = Js.Dict.empty()
        Js.Dict.set(dict, "secret", Js.Json.string(Option.getWithDefault(secret, "")))
        Js.Json.object_(dict)
      }

      X.post(`${Config.base_url}/users/email_confirmation`, data)
      -> Promise.thenResolve(_ =>
        Js.log("Successfully confirmed")
      )
      -> ignore
  }

  <>
    <Title style=X.styles["center"]> { "Check your emails and enter your token" -> React.string } </Title>

    <TextInput
      mode=#flat
      label="Secret"
      testID="secret-input"
      value=Option.getWithDefault(secret, "")
      onChangeText={text => setSecret(_ => text == "" ? None : Some(text))}
      onSubmitEditing=onSubmit
    />

    <Button mode=#contained onPress=onSubmit>
      { "Confirmer mon email" -> React.string }
    </Button>
  </>
}