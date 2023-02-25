external parseUsers: Js.Json.t => array<User.t> = "%identity"

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  <View style=X.styles["margin-x"]>
    {
      switch state.user {
      | Some(user) =>
        <>
          <Text style=X.styles["center"]>{ `Logged as ${user.email}` -> React.string }</Text>
          <Button mode=#contained onPress={_ => dispatch(User_Logout)} style=X.styles["margin-x"]>
            { "Logout" -> React.string }
          </Button>
        </>
      | None =>
        <>
          <Text>{ `Not logged` -> React.string }</Text>
        </>
      }
    }

    {
      let title = "My elections (as administrator)"
      <ElectionList title elections=[] />
    }

    {
      let title = "My elections (as trustee)"
      let elections =  Array.keep(state.elections, (election) => {
        Array.some(state.trustees, (trustee) => {
          let election_pubkey = switch election.trustees {
          | Some(election_trustees) => election_trustees -> Belenios.Trustees.of_str -> Belenios.Trustees.pubkey
          | None => ""
          }
          election_pubkey == trustee.pubkey
        })
      })
      <ElectionList title elections=elections />
    }

    {
      let title = "My elections (as voter)"
      let elections =  Array.keep(state.elections, (election) => {
        let creds : array<string> = election.creds -> Option.map(Belenios.Credentials.parse) -> Option.getWithDefault([])
        Array.some(creds, (cred) => {
          Array.some(state.tokens, (token) => token.public == cred)
        })
      })
      <ElectionList title elections=elections />
    }

    <Admin_User_List />
  </View>
}
