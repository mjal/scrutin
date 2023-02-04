open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

type results_t = {
  result: array<array<int>>
}

@val external parse_results: (string) => results_t = "JSON.parse"

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

  <View>
    <Title style=X.styles["title"]>
      {state.election.name -> React.string}
    </Title>
    <Title style=X.styles["subtitle"]>
      {
        if state.election.result != "" {
          let results : results_t = parse_results(state.election.result)
          Js.log(results)
          {`${Option.getExn(Option.getExn(results.result[0])[0]) -> Int.toString} vs ${Option.getExn(Option.getExn(results.result[0])[1]) -> Int.toString}` -> React.string}
        } else {
          "The election is not closed yet" -> React.string
        }
        }
    </Title>

    /*
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
    */
	</View>
}