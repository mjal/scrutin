open Helper
open ReactNative
open Paper

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
    <List.Section title="Votants">
      {
        state.election.voters
        -> Js.Array2.map(voter => {
          <Voter name=voter.name key=voter.name dispatch />
        })
        -> React.array
      }
    </List.Section>
    <View>
		  <TextInput mode=#flat value={email} onChangeText={txt => setEmail(_ => txt)} />
		  <Button onPress>{rs("Ajouter")}</Button>
    </View>
	</View>
}
