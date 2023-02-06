open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (privkey, setPrivkey) = React.useState(_ => None)
  let (showSnackbar, setShowSnackbar) = React.useState(_ => false)

  let nb_ballots = Array.length(state.election.ballots) -> Int.toString
  let nb_votes   = state.election.ballots
    -> Array.keep((ballot) => Option.isSome(ballot.ciphertext))
    -> Array.length
    -> Int.toString

  React.useEffect1(() => {
    switch state.election.trustees {
      | None => ()
      | Some(trustees) => {
        let pubkey = Belenios.Trustees.pubkey(Belenios.Trustees.of_str(trustees))

        ReactNativeAsyncStorage.getItem(pubkey)
        -> Promise.thenResolve((res) => {
          setPrivkey(_ => Js.Null.toOption(res))
        })
        -> ignore
      }
    }
    None
  }, [state.election.trustees])

  let tally = _ => {
    switch privkey {
    | Some(sPrivkey) => {
      let params = Option.getExn(state.election.params)
      let ballots =
        state.election.ballots
        -> Array.map((ballot) => ballot.ciphertext)
        -> Array.keep(Option.isSome)
        -> Array.map((ciphertext) => Belenios.Ballot.of_str(Option.getExn(ciphertext)))
      let trustees = Belenios.Trustees.of_str(Option.getExn(state.election.trustees))
      let pubcreds : array<string> = %raw(`JSON.parse(state.election.creds)`)
      let tPrivkey = Belenios.Trustees.Privkey.of_str(sPrivkey)
      let (a, b) = Belenios.Election.decrypt(params, ballots, trustees, pubcreds, tPrivkey)
      let res = Belenios.Election.result(params, ballots, trustees, pubcreds, a, b)

      dispatch(Action.Election_PublishResult(res))
    }
    | None => setShowSnackbar(_ => true)
    }
    Js.log(privkey)
  }

  let (view, setView) = React.useState(_ => "home")

  <View>
    <Title style=X.styles["title"]>
      {state.election.name -> React.string}
    </Title>
    <X.SegmentedButtons
      value=view
      onValueChange={(view) => setView(_ => view)}
      buttons={[
        { value: "home", label: "home" },
        { value: "vote", label: "vote" },
        { value: "results", label: "results" }
      ]}
    />
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
      <X.Col>
        <Button onPress={_ => dispatch(Navigate(Route.ElectionResult(state.election.id)))}>
          {"Results" -> React.string}
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