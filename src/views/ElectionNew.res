open ReactNative

@react.component
let make = () => {
  let (state, dispatch) = State.useContextReducer()

  <View>
    <Paper.TextInput
      mode=#flat
      label="Nom de l'élection"
			value=state.election.name
      onChangeText={text => dispatch(SetElectionName(text))}
    >
    </Paper.TextInput>
    <Text style=X.styles["title"]>{"Choices" -> React.string}</Text>
    <ChoiceList />
    <Text style=X.styles["title"]>{"Voters" -> React.string}</Text>
    <VoterList />
    <View style=X.styles["row"]>
      <View style=X.styles["col"]>
        <Button color=Color.rosybrown title="Back" onPress={_ => dispatch(Action.Navigate(Route.Home))}/>
      </View>
      <View style=X.styles["col"]>
        <Button title="Create" onPress={_ => dispatch(PostElection)}/>
      </View>
    </View>
	</View>
}