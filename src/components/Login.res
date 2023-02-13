open ReactNative
open! Paper

@react.component
let make = () => {
  let (_, dispatch) = Context.use()
  let (email, setEmail) = React.useState(_ => "")
  let (password, setPassword) = React.useState(_ => "")
  let (error, setError) = React.useState(_ => "")

  let onSubmit = _ => {
    let user : User.t = { id: None, email, password }
    X.post(`${Config.api_url}/signin`, user -> User.to_json)
    -> Promise.thenResolve((response) => {
      let status  = Webapi.Fetch.Response.status(response)
      Webapi.Fetch.Response.json(response)
      -> Promise.thenResolve((content) => {
        if status == 200 {
          let dict = Js.Json.decodeObject(content) -> Option.getExn
          let id = Js.Dict.get(dict, "id") -> Option.flatMap(Js.Json.decodeNumber) -> Option.map(Int.fromFloat)
          Js.log(Js.Dict.get(dict, "id"))
          Js.log(Js.Dict.get(dict, "id") -> Option.flatMap(Js.Json.decodeNumber))
          Js.log(Js.Dict.get(dict, "id") -> Option.flatMap(Js.Json.decodeNumber) -> Option.map(Int.fromFloat))
          dispatch(User_Login({...user, id}))
        } else {
          setError(_ => "Error login in")
        }
      })
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
      onSubmitEditing=onSubmit
    />
    <Divider />
    <Button mode=#contained onPress=onSubmit style=X.styles["margin-x"]>
      {"Login" -> React.string}
    </Button>
  </View>
}