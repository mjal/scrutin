open ReactNative; open Helper

@react.component
let make = (~dispatch: Action.t => (), ~state: State.state) => {
	let (firstName, setFirstName) = React.useState(_ => "")
	let (lastName, setLastName) = React.useState(_ => "")

  let onChangeFirstName = value => {
    setFirstName(value)
  }

  let onChangeLastName = value => {
    setLastName(value)
  }

  let onPress = e => {
    dispatch(Action.AddCandidate(lastName ++ " " ++ firstName))
    setFirstName(_ => "")
    setLastName(_ => "")
  }

	<View>
		<Text>{"Candidats"->rs}</Text>
    <View>
      {
        state.election.candidates
        -> Js.Array2.map(candidate =>
          <Candidate key={candidate.name} name={candidate.name} dispatch={dispatch} />
        )
        -> React.array
      }
		</View>
    <View>
		  <TextInput value={firstName} /*onChangeText=setFirstName*/ />
		  <TextInput value={lastName}  /*onChangeText=setLastName*/ />
		  <Button onPress title="Ajouter" />
    </View>
	</View>
}
