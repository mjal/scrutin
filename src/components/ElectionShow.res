open ReactNative
open! Paper

type choice_t = ElectionBooth_ChoiceSelect.choice_t

@react.component
let make = () => {
  let (state, dispatch) = State.useContexts()

  let nb_ballots = Array.length(state.election.ballots) -> Int.toString
  let nb_votes   = state.election.ballots
    -> Array.keep((ballot) => ballot.ciphertext == "")
    -> Array.length
    -> Int.toString

  <View>
    <Title style=X.styles["title"]>
      {state.election.name -> React.string}
    </Title>
    <Title style=X.styles["subtitle"]>
      {`${nb_ballots}/${nb_votes} voted` -> React.string}
    </Title>

    <View style=X.styles["separator"] />
    <View style=X.styles["row"]>
      <View style=X.styles["col"]>
        <Button onPress={_ => dispatch(Action.Navigate(Route.ElectionBooth(state.election.id))) }>
          {"Vote" -> React.string}
        </Button>
      </View>
      <View style=X.styles["col"]>
        <Button onPress={_ => ()}>
          {"Close" -> React.string}
        </Button>
      </View>
    </View>
	</View>
}