@react.component
let make = () => {
  let (name, setName) = React.useState(_ => "")
  let (desc, setDesc) = React.useState(_ => "")
  let (choices, setChoices) = React.useState(_ => "")

  <>
    <TextInput
      mode=#flat
      label="Nom de l'élection"
      testID="election-name"
			value=name
      onChangeText={text => setName(_ => text)}
    />

    <TextInput
      mode=#flat
      label="Description"
      testID="election-desc"
			value=desc
      onChangeText={text => setDesc(_ => text)}
    />

    <Election_New_ChoiceList
      onUpdate={choices => setChoices(_ => choices)} />
  </>
}
/*
@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let (visibleVoter, setVisibleVoter) = React.useState(_ => false)
  let (visibleChoice, setVisibleChoice) = React.useState(_ => false)

  let onSubmit = _ => {
    if Array.length(state.election.choices) < 2 {
      setVisibleChoice(_ => true)
    } else if Array.length(state.election.voters) < 1 {
      setVisibleVoter(_ => true)
    } else {
      dispatch(Election_Post)
    }
  }

  <View>
    <TextInput
      mode=#flat
      label="Nom de l'élection"
      testID="election-name"
			value=state.election.name
      onChangeText={text => dispatch(Election_SetName(text))}
    >
    </TextInput>
    
    <ElectionNew_ChoiceList />
    <ElectionNew_VoterList />

    <Button mode=#contained onPress=onSubmit>
      {"Create election" -> React.string}
    </Button>

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
*/
