open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
	let (email, setEmail) = React.useState(_ => "")
	//let (error, setError) = React.useState(_ => false)
  let (showModal, setshowModal) = React.useState(_ => false)
  let (visibleError, setVisibleError) = React.useState(_ => false)

	let addVoter = _ => {
    if EmailValidator.validate(email) {
      dispatch(Election_AddVoter(email))
      setEmail(_ => "")
      setshowModal(_ => false)
    } else {
      setVisibleError(_ => true)
    }
	}

	<View testID="voter-list">
    <X.Row>
      <X.Col>
        <Text style=X.styles["title"]>{"Voters" -> React.string}</Text>
      </X.Col>
      <X.Col><Text>{React.string("")}</Text></X.Col>
      <X.Col>
        <Button
          mode=#contained
          onPress={_ => setshowModal(_ => true)}
        >
          {"Ajouter" -> React.string}
        </Button>
      </X.Col>
    </X.Row>

    <View>
      {
        state.election.voters
        -> Array.mapWithIndex((index, voter) => {
          <ElectionNew_VoterItem index voter=voter key=voter.email />
        })
        -> React.array
      }
    </View>

    <HelperText _type=#error visible={ Array.length(state.election.voters) < 1} style=X.styles["center"]>
      {"Il faut au moins 1 votant !"->React.string}
    </HelperText>

    <Portal>
      <Modal visible={showModal} onDismiss={_ => setshowModal(_ => false)}>
        <View style=StyleSheet.flatten([X.styles["modal"], X.styles["layout"]])>
          <TextInput
            mode=#flat
            label="Email du participant"
            testID="voter-email"
            autoFocus=true
            value=email
            onChangeText={text => setEmail(_ => text)}
            onSubmitEditing=addVoter
          />
          <X.Row>
            <X.Col>
              <Button onPress={_ => { setEmail(_ => ""); setshowModal(_ => false)} }>{"Retour"->React.string}</Button>
            </X.Col>
            <X.Col>
              <Button mode=#contained onPress=addVoter>{"Ajouter"->React.string}</Button>
            </X.Col>
          </X.Row>
        </View>
      </Modal>
      <Snackbar
        visible={visibleError}
        onDismiss={_ => setVisibleError(_ => false)}
      >
        {"Invalid email" -> React.string}
      </Snackbar>
    </Portal>
	</View>
}