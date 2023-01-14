open ReactNative

@react.component
let make = () => {
  let (state, dispatch) = State.useContextReducer()

  <View>
    <Text>{state.election.name->rs}</Text>
    <TextInput
			value=state.election.name
      onChangeText={text => dispatch(SetElectionName(text))}
    >
    </TextInput>
	</View>
}