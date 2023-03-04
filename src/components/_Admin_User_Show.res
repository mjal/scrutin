@react.component
let make = () => {
  <></>
}
/*
@react.component
let make = (~user: User.t) => {
  let delete = _ => {
    let data = {
      let dict = Js.Dict.empty()
      Js.Dict.set(dict, "email", Js.Json.string(user.email))
      Js.Json.object_(dict)
    }
    X.post(`${Config.api_url}/users/delete`, data)
    -> ignore
  }

  let setAdmin = (isAdmin) => {
    let data = {
      let dict = Js.Dict.empty()
      Js.Dict.set(dict, "email", Js.Json.string(user.email))
      Js.Dict.set(dict, "admin", Js.Json.boolean(isAdmin))
      Js.Json.object_(dict)
    }
    X.post(`${Config.api_url}/users/update`, data)
    -> ignore
  }

  <>
    <Title style=X.styles["center"]>
      { user.email -> React.string }
    </Title>
    <Button onPress={_ => setAdmin(true)}>
      { "Promote admin" -> React.string }
    </Button>
    <Button onPress={_ => setAdmin(false)}>
      { "Demote admin" -> React.string }
    </Button>
    <Button onPress=delete>
      { "Delete" -> React.string }
    </Button>
  </>
}
*/
