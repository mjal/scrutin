/*
@react.component
let make = () => {
  let (email, setEmail) = React.useState(_ => "")
  let (loading, setLoading) = React.useState(_ => false)
  let (_state, dispatch) = Context.use()
  let (error, setError) = React.useState(_ => "")

  let onSubmit = _ => {
    if !EmailValidator.validate(email) {
      setError(_ => "Invalid email")
    } else {
      setLoading(_ => true)

      let data = {
        let dict = Js.Dict.empty()
        Js.Dict.set(dict, "email", Js.Json.string(email))
        Js.Json.object_(dict)
      }

      X.post(`${Config.api_url}/users`, data)
      -> Promise.thenResolve(_ =>
        dispatch(Action.Navigate(Route.User_Register_Confirm(None, None)))
      )
      -> ignore
    }
  }

  <>
    <Title style=X.styles["center"]> { "Ready to vote ?" -> React.string } </Title>

    { if error == "" { <></> } else {
      <HelperText _type=#error>
        { error -> React.string }
      </HelperText>
    } }

    <TextInput
      mode=#flat
      label="Email"
      testID="email-input"
      value=email
      onChangeText={text => setEmail(_ => text)}
      onSubmitEditing=onSubmit
    />

    <Button mode=#contained onPress=onSubmit>
      {loading ? "Loading..." -> React.string : "Next" -> React.string}
    </Button>
  </>
}
*/
