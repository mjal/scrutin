@react.component
let make = () => {
  let (_, _dispatch) = Context.use()
  let (email, setEmail) = React.useState(_ => "")
  let (error, _setError) = React.useState(_ => "")

  let onSubmit = _ => {
    ()
    /*
    if !EmailValidator.validate(email) {
      setError(_ => "Invalid email")
    } else {
      Webapi.Fetch.fetch(j`${Config.api_url}/users?email=${email}`)
      //-> Promise.then(Webapi.Fetch.Response.json)
      -> Promise.thenResolve((response) => {
        let status  = Webapi.Fetch.Response.status(response)
        Webapi.Fetch.Response.json(response)
        -> Promise.thenResolve((content) => {
          if status == 200 {
            let dict = Js.Json.decodeObject(content) -> Option.getExn
            let id = Js.Dict.get(dict, "id") -> Option.flatMap(Js.Json.decodeNumber) -> Option.map(Int.fromFloat)
            dispatch(User_Login({...user, id}))
          } else {
            setError(_ => "Error login in")
          }
        })
      })
      -> ignore
    }
    */
  }

  <View style=X.styles["margin-x"]>
    <Title style=X.styles["title"]>{ "Enter your email to join..." -> React.string }</Title>
    { if error == "" { <></> } else {
      <HelperText _type=#error>
        { error -> React.string }
      </HelperText>
    } }
    <TextInput
      mode=#flat
      label="Email"
      testID="login-email"
      value=email
      onChangeText={text => setEmail(_ => text)}
    />
    <Divider />
    <Button mode=#contained onPress=onSubmit style=X.styles["margin-x"]>
      {"Continue" -> React.string}
    </Button>
  </View>
}
