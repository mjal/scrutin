open ReactNative
open! Paper

@react.component
let make = () => {
  let (_, dispatch) = Context.use()
  let (email, setEmail) = React.useState(_ => "")
  let (password, setPassword) = React.useState(_ => "")
  let (error, setError) = React.useState(_ => "")

  let onSubmit = _ => {
    let user : User.t = { email, password }
    X.post(`${Config.api_url}/signin`, user -> User.to_json)
    -> Promise.thenResolve(Webapi.Fetch.Response.status)// Webapi.Fetch.Response.json)
    -> Promise.thenResolve((status) => {
      if status == 200 {
        dispatch(User_Login(user))
      } else {
        setError(_ => "Error login in")
      }
    })
    -> ignore
  }

  <View style=X.styles["margin-x"]>
    <Title style=X.styles["title"]>{ "Please login (only beta-testers can create elections)" -> React.string }</Title>
    { if error == "" { <></> } else {
      <HelperText _type=#error>
        { error -> React.string }
      </HelperText>
    } }
    <TextInput
      mode=#flat
      label="Username"
      value=email
      onChangeText={text => setEmail(_ => text)}
    />
    <TextInput
      secureTextEntry=true
      mode=#flat
      label="Password"
      value=password
      onChangeText={text => setPassword(_ => text)}
      onKeyPress={key => X.isKeyEnter(key) ? onSubmit() : ()}
    />
    <Divider />
    <Button mode=#contained onPress=onSubmit style=X.styles["margin-x"]>
      {"Login" -> React.string}
    </Button>
  </View>
}