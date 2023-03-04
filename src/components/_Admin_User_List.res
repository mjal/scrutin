@react.component
let make = () => {
  <></>
}
/*
external parseUsers: Js.Json.t => array<User.t> = "%identity"

@react.component
let make = () => {
  let (users, setUsers) = React.useState(_ => [])
  let (_state, dispatch) = Context.use()

  React.useEffect0(_ => {
    Webapi.Fetch.fetch(j`${Config.api_url}/users`)
    -> Promise.then(Webapi.Fetch.Response.json)
    -> Promise.thenResolve((o) => {
      let users = parseUsers(o)
      setUsers(_ => users)
    }) -> ignore
    None
  })

  <List.Section title="Utilisateurs">
    {
      Array.map(users, (user) => {
        <List.Item
          key=Int.toString(user.id)
          title=user.email
          left={_ => <List.Icon icon=Icon.name("account") />}
          right={_ => <List.Icon icon=Icon.name("pencil") />}
          onPress={_ => dispatch(Navigate(Admin_User_Show(user)))}
        />
      })
      -> React.array
    }
  </List.Section>
}
*/
