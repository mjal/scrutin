open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

@react.component
let make = () => {
  let (state, dispatch) = State.useContexts()
  let (privkey, setPrivkey) = React.useState(_ => None)
  let (showSnackbar, setShowSnackbar) = React.useState(_ => false)

  let nb_ballots = Array.length(state.election.ballots) -> Int.toString
  let nb_votes   = state.election.ballots
    -> Array.keep((ballot) => ballot.ciphertext != "")
    -> Array.length
    -> Int.toString

  React.useEffect1(() => {
    if state.election.trustees != "" {
      let pubkey = Belenios.Trustees.pubkey(Belenios.Trustees.of_str(state.election.trustees))

      ReactNativeAsyncStorage.getItem(pubkey)
      -> Promise.thenResolve((res) => {
        setPrivkey(_ => Js.Null.toOption(res))
      })
      -> ignore
    }
    None
  }, [state.election.trustees])

  let tally = _ => {
    switch privkey {
    | Some(sPrivkey) => {
      let params = Belenios.Election.of_str(state.election.params)
      let ballots = Array.map(state.election.ballots, (ballot) => Belenios.Ballot.of_str(ballot.ciphertext))
      let trustees = Belenios.Trustees.of_str(state.election.trustees)
      Js.log(state.election.creds)
      let pubcreds : array<string> = %raw(`JSON.parse(state.election.creds)`)
      let tPrivkey = Belenios.Trustees.Privkey.of_str(sPrivkey)
      let (a, b) = Belenios.Election.decrypt(params, ballots, trustees, pubcreds, tPrivkey)
      let res = Belenios.Election.result(params, ballots, trustees, pubcreds, a, b)
      Js.log(res)
    }
    | None => setShowSnackbar(_ => true)
    }
    Js.log(privkey)
  }

  <View>
    <Title style=X.styles["title"]>
      {state.election.name -> React.string}
    </Title>
    <Title style=X.styles["subtitle"]>
      {`${nb_votes}/${nb_ballots} voted` -> React.string}
    </Title>

    <View style=X.styles["separator"] />
    <X.Row>
      <X.Col>
        <Button onPress={_ => dispatch(Action.Navigate(Route.ElectionBooth(state.election.id))) }>
          {"Vote" -> React.string}
        </Button>
      </X.Col>
      <X.Col>
        <Button onPress=tally>
          {"Tally" -> React.string}
        </Button>
      </X.Col>
    </X.Row>

    <Portal>
      <Snackbar
        visible={showSnackbar}
        onDismiss={_ => setShowSnackbar(_ => false)}
      >
        {"You don't have the election private key" -> React.string}
      </Snackbar>
    </Portal>
	</View>
}