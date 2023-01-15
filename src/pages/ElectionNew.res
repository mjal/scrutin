open ReactNative

let styles = {
  open Style
  StyleSheet.create({
    "section-title": textStyle(
      ~textAlign=#center,
      ~fontSize=20.0,
      ()
    )
  })
}

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
    <Text style=styles["section-title"]>{"Choices"->rs}</Text>
    <ChoiceList />
    <Text style=styles["section-title"]>{"Voters"->rs}</Text>
    <VoterList />
    <Button title="Create" onPress={_ => ()}/>
	</View>
}