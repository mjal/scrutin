open ReactNative; open Helper

@react.component
let make = (~state: State.state, ~dispatch: Action.t => unit) => {
	let (email, setEmail) = React.useState(_ => "")

	let addVoter = _ => {
		dispatch(AddVoter(email))
		setEmail(_ => "")
	}

  let onChange = (event) =>
    setEmail(ReactEvent.Form.currentTarget(event)["value"])

	let onPress = _ => addVoter()

	<View>
		<Text>{"Votants"->rs}</Text>
    <View>
      {
        state.election.voters
        -> Js.Array2.map(voter => <Voter key={voter.name} name={voter.name} dispatch={dispatch} />)
        -> React.array
      }
    </View>
		<TextInput value={email} onChangeText={(s) => setEmail(_ => s)} />
		<Button onPress title="Ajouter" />
	</View>
}
