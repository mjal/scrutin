open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (showSnackbar, setShowSnackbar) = React.useState(_ => false)

  let nb_ballots = Array.length(state.election.ballots) -> Int.toString
  let nb_votes   = state.election.ballots
    -> Array.keep((ballot) => Option.getWithDefault(ballot.ciphertext, "") == "")
    -> Array.length
    -> Int.toString

  let tally = _ => {
    state.trustees -> Js.log
    let trustee = state.trustees
    -> Array.getBy((trustee) => {
      trustee.pubkey == state.election.trustees->Option.map(Belenios.Trustees.of_str)->Option.map(Belenios.Trustees.pubkey)->Option.getWithDefault("")
    })

    switch trustee {
    | None => setShowSnackbar(_ => true)
    | Some(trustee) => {
      let params = Option.getExn(state.election.params)
      let ballots =
        state.election.ballots
        -> Array.map((ballot) => ballot.ciphertext)
        -> Array.keep(Option.isSome)
        -> Array.map((ciphertext) => Belenios.Ballot.of_str(Option.getExn(ciphertext)))
      let trustees = Belenios.Trustees.of_str(Option.getExn(state.election.trustees))
      let pubcreds : array<string> = %raw(`JSON.parse(state.election.creds)`)
      let (a, b) = Belenios.Election.decrypt(params, ballots, trustees, pubcreds, trustee.privkey)
      let res = Belenios.Election.result(params, ballots, trustees, pubcreds, a, b)
      dispatch(Action.Election_PublishResult(res))
    }
    }
  }

  let (view, setView) = React.useState(_ => "home")

  <View>
    <Title style=X.styles["title"]>
      {state.election.name -> React.string}
    </Title>
    //<X.SegmentedButtons
    //  value=view
    //  onValueChange={(view) => setView(_ => view)}
    //  buttons={[
    //    { value: "home", label: "home" },
    //    { value: "vote", label: "vote" },
    //    { value: "results", label: "results" }
    //  ]}
    ///>
    <Title style=X.styles["subtitle"]>
      {`${nb_votes}/${nb_ballots} voted` -> React.string}
    </Title>

    <View style=X.styles["separator"] />

    <View>
      <ElectionResult />
    </View>

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
      //<X.Col>
      //  <Button onPress={_ => dispatch(Navigate(Route.ElectionResult(state.election.id)))}>
      //    {"Results" -> React.string}
      //  </Button>
      //</X.Col>
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