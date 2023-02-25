@react.component
let make = () => {
  let (secret, setSecret) = React.useState(_ => None)
  let (email , setEmail)  = React.useState(_ => None)
  let (showDetails, setShowDetails) = React.useState(_ => false)
  let (state, dispatch) = Context.use()

  React.useEffect(_ => {
    let email  = URL.getSearchParameter("email")
    let secret = URL.getSearchParameter("secret")
    if email != ""  { setEmail(_  => Some(email))  }
    if secret != "" { setSecret(_ => Some(secret)) }
    None
  })

  let onSubmit = _ => {
    switch (email, secret) {
    |  (Some(email), Some(secret)) => {
      let (publicKey, secretKey) = Sjcl.Ecdsa.new()
      let data = {
        let dict = Js.Dict.empty()
        Js.Dict.set(dict, "email", Js.Json.string(email))
        Js.Dict.set(dict, "secret", Js.Json.string(secret))
        Js.Dict.set(dict, "publicKey", Js.Json.string(Sjcl.Ecdsa.PublicKey.toHex(publicKey)))
        Js.Json.object_(dict)
      }
      X.post(`${Config.api_url}/users/email_confirmation`, data)
      -> Promise.thenResolve(_ => {
        let user : User.t = {
          id: 0,
          email,
          publicKey: Sjcl.Ecdsa.PublicKey.toHex(publicKey),
          secretKey: Some(Sjcl.Ecdsa.SecretKey.toHex(secretKey))
        }
        dispatch(User_Login(user))
      }) -> ignore
    }
    | _ => let () = %raw(`window.alert('Empty email or secret')`); ()
    }
  }

  <>
    <Title style=X.styles["center"]> { "Enregistrement..." -> React.string } </Title>

    { if showDetails {
      <>
        <TextInput
          mode=#flat
          label="Email"
          testID="email-input"
          value=Option.getWithDefault(email, "")
          onChangeText={text => setEmail(_ => text == "" ? None : Some(text))}
        />

        <TextInput
          mode=#flat
          label="Secret"
          testID="secret-input"
          value=Option.getWithDefault(secret, "")
          onChangeText={text => setSecret(_ => text == "" ? None : Some(text))}
        />
      </>
      } else {
        <></>
      }
    }

    <Button mode=#contained onPress=onSubmit>
      { "S'enregistrer" -> React.string }
    </Button>

    { if showDetails {
      <Button onPress={_ => setShowDetails(_ => false)}>{ "Cacher les details" -> React.string }</Button>
    } else {
      <Button onPress={_ => setShowDetails(_ => true)}>{ "Afficher les details" -> React.string }</Button>
    } }
  </>
}
