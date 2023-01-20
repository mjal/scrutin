open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, dispatch) = State.useContextReducer()
  let (visibleVoter, setVisibleVoter) = React.useState(_ => false)
  let (visibleChoice, setVisibleChoice) = React.useState(_ => false)

  let onSubmit = _ => {
    if Array.length(state.election.choices) < 2 {
      setVisibleChoice(_ => true)
    } else if Array.length(state.election.voters) < 1 {
      setVisibleVoter(_ => true)
    } else {
      dispatch(PostElection)
    }
  }

  <View>
    <TextInput
      mode=#flat
      label="Nom de l'élection"
			value=state.election.name
      onChangeText={text => dispatch(SetElectionName(text))}
    >
    </TextInput>
    <Text style=X.styles["title"]>{"Choices" -> React.string}</Text>
    <ElectionNew_ChoiceList />
    <Text style=X.styles["title"]>{"Voters" -> React.string}</Text>
    <ElectionNew_VoterList />
    <View style=X.styles["row"]>
      <View style=X.styles["col"]>
        <Button mode=#outlined onPress={_ => dispatch(Action.Navigate(Route.Home))}>
          <Text>{"Back" -> React.string}</Text>
        </Button>
      </View>
      <View style=X.styles["col"]>
        <Button mode=#contained onPress=onSubmit>
          <Text>{"Create election" -> React.string}</Text>
        </Button>
      </View>
    </View>

    <Portal>
      <Snackbar
        visible={visibleChoice}
        onDismiss={_ => setVisibleChoice(_ => false)}
      >
        {"You should have at least 2 choices" -> React.string}
      </Snackbar>

      <Snackbar
        visible={visibleVoter}
        onDismiss={_ => setVisibleVoter(_ => false)}
      >
        {"You should have at least 1 voter" -> React.string}
      </Snackbar>
    </Portal>
	</View>
}