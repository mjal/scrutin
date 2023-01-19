open ReactNative

@react.component
let make = () => {
  let (state, dispatch) = State.useContextReducer()

  <View>
    <Text>{state.election.name -> React.string}</Text>
    <TextInput
      placeholder="Nom de l'élection"
			value=state.election.name
      onChangeText={text => dispatch(SetElectionName(text))}
    >
    </TextInput>
    <Text style=X.styles["title"]>{"Choices" -> React.string}</Text>
    <ChoiceList />
    <Text style=X.styles["title"]>{"Voters" -> React.string}</Text>
    <VoterList />
    <Button title="Create" onPress={_ => dispatch(PostElection)}/>
	</View>
}