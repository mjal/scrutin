open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, dispatch) = State.useContexts()

	let (email, setEmail) = React.useState(_ => "")
	let (error, setError) = React.useState(_ => false)

	let addVoter = _ => {
    if EmailValidator.validate(email) {
      dispatch(AddVoter(email))
      setEmail(_ => "")
    }
	}

  let onChangeText = txt => {
      setEmail(_ => txt)
    if EmailValidator.validate(email) {
      setError(_ => false)
    } else {
      setError(_ => true)
    }
  }

	<View>
    <View>
      {
        state.election.voters
        -> Js.Array2.map(voter => {
          <ElectionNew_VoterItem voter=voter key=voter.email />
        })
        -> React.array
      }
    </View>
    <X.Row>
      <X.Col>
		    <TextInput
          mode=#flat
          value={email}
          onChangeText
          placeholder="Email"
          error
        />
      </X.Col>
      <X.Col>
        //<View style=styles["smallButton"]>
          <Button mode=#contained onPress={_ => addVoter()}>
            <Text>{"Ajouter" -> React.string}</Text>
          </Button>
        //</View>
      </X.Col>
    </X.Row>
	</View>
}