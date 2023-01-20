open ReactNative

@react.component
let make = () => {
  let (state, dispatch) = State.useContextReducer()

  <View>
    <Text>{state.election.name -> React.string}</Text>
    <Text style=X.styles["title"]>{"Choices" -> React.string}</Text>
    <ElectionNew_ChoiceList />
    <Text style=X.styles["title"]>{"Voters" -> React.string}</Text>
    <ElectionNew_VoterList />
    <View style=X.styles["row"]>
      <View style=X.styles["col"]>
        <Button color=Color.rosybrown title="Home" onPress={_ => dispatch(Action.Navigate(Route.Home))}/>
      </View>
      <View style=X.styles["col"]>
        <Button title="Vote" onPress={_ => ()}/>
      </View>
      <View style=X.styles["col"]>
        <Button title="Close" onPress={_ => ()}/>
      </View>
    </View>
	</View>
}