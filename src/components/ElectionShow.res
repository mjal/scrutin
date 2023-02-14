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

  <View>
    <Title style=X.styles["title"]>
      {state.election.name -> React.string}
      <Chip mode=#flat icon=Paper.Icon.name("information") style=X.styles["margin-x"]>
        { if Option.isNone(state.election.result) { "En cours" } else { "Terminée" } -> React.string }
      </Chip>
    </Title>

    <Title style=X.styles["subtitle"]>
      {`${nb_votes} personnes sur ${nb_ballots} ont voté` -> React.string}
    </Title>

    { switch state.election.result {
    | None => <ElectionBooth />
    | Some(_result) => <ElectionResult />
    }}

    <Button mode=#contained onPress={_ => tally()} >
      {"Tally" -> React.string}
    </Button>

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