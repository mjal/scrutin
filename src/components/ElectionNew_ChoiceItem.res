open ReactNative;
open! Paper;

@react.component
let make = (~choice: Choice.t) => {
  let (_, dispatch) = State.useContexts()

    <List.Item
      title=choice.name
      left={_ => <List.Icon icon=Icon.name("vote") />}
      onPress={_ => ()}
      right={_ =>
        // Not working...
        <Button onPress={_ => {Js.log(1); dispatch(Action.RemoveChoice(choice.name))}}>
          <List.Icon icon=Icon.name("delete") />
        </Button>
      }
      //onPress={_ => dispatch(Action.Navigate(Route.ElectionShow(election.id)))}
    />


  /*
  <View style=X.styles["row"]>
    <View style=X.styles["col"]>
    <Text>{choice.name ->  React.string}</Text>
    </View>
    <View style=X.styles["col"]>
      <Button color=Color.rosybrown onPress={_ => dispatch(Action.RemoveChoice(choice.name)) } title="Remove"></Button>
    </View>
  </View>
  */
}
