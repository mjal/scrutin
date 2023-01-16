open ReactNative;

@react.component
let make = (~choice: Choice.t) => {
  let (_, dispatch) = State.useContextReducer()

  <View style=shared_styles["row"]>
    <View style=shared_styles["col"]>
    <Text>{choice.name->rs}</Text>
    </View>
    <View style=shared_styles["col"]>
      <Button color=Color.rosybrown onPress={_ => dispatch(Action.RemoveChoice(choice.name)) } title="Remove"></Button>
    </View>
  </View>
}
