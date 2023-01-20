open ReactNative
open! Paper

@react.component
let make = () => {
  let (state, dispatch) = State.useContextReducer()

  <View>
    <Title style=X.styles["title"]>{state.election.name -> React.string}</Title>
    <View style=X.styles["separator"] />
    <ElectionShow_ChoiceSelect />
    <Text style=X.styles["title"]>{"Voters" -> React.string}</Text>
    <ElectionNew_VoterList />
    <View style=X.styles["row"]>
      <View style=X.styles["col"]>
        <Button onPress={_ => dispatch(Action.Navigate(Route.Home))}>
          {"Home" -> React.string}
        </Button>
      </View>
      <View style=X.styles["col"]>
        <Button onPress={_ => ()}>
          {"Vote" -> React.string}
        </Button>
      </View>
      <View style=X.styles["col"]>
        <Button onPress={_ => ()}>
          {"Results" -> React.string}
        </Button>
      </View>
    </View>
	</View>
}