open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  let user_id = state.user -> Option.flatMap(user => user.id) -> Option.getWithDefault(0)

  <View style=X.styles["margin-x"]>
    <Button mode=#contained onPress={_ => dispatch(User_Logout)} style=X.styles["margin-x"]>
      { "Logout" -> React.string }
    </Button>

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
  </View>
}