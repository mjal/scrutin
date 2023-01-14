open ReactNative

@react.component
let make = () => {
  let (state, dispatch) = State.useContextReducer()

  <View>
    <Text>{state.election.name->rs}</Text>
    <TextInput
      placeholder="Nom de l'élection"
			value=state.election.name
      onChangeText={text => dispatch(SetElectionName(text))}
    >
    </TextInput>
    <Text>{"Choice list"->rs}</Text>
    <Text>{"Voter list"->rs}</Text>
    <Button title="Create an election" onPress={_ => ()}/>
	</View>
}