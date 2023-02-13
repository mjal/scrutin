open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (showSnackbar, setShowSnackbar) = React.useState(_ => false)

  let nb_ballots = Array.length(state.election.ballots) -> Int.toString
  let nb_votes   = state.election.ballots
    -> Array.keep((ballot) => Option.getWithDefault(ballot.ciphertext, "") != "")
    -> Array.length
    -> Int.toString

  let tally = _ => {
    let trustee = Array.getBy(state.trustees, (trustee) => {
      let election_pubkey = state.election.trustees
      -> Option.map(Belenios.Trustees.of_str)
      -> Option.map(Belenios.Trustees.pubkey)
      -> Option.getWithDefault("")

      trustee.pubkey == election_pubkey
    })

    switch trustee {
    | None => setShowSnackbar(_ => true)
    | Some(trustee) => {
      dispatch(Action.Election_Tally(trustee))
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
        <Button onPress={_ => tally()} >
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