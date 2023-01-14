open ReactNative

let styles = {
  open Style
  StyleSheet.create({
    "row": viewStyle(
      ~flexDirection=#row,
      ~padding=10.0->dp,
      ()
    ),
    "col": viewStyle(
      ~flex=1.0,
      ~padding=5.0->dp,
      ()
    ),
    "smallButton": textStyle(
      ~height=15.0->dp,
      ()
    )
  })
}

@react.component
let make = (~voter: Voter.t) => {
  let (_, dispatch) = State.useContextReducer()

  <View style=styles["row"]>
    <View style=styles["col"]>
    <Text>{voter.email->rs}</Text>
    </View>
    <View style=styles["col"]>
      <Button color=Color.rosybrown onPress={_ => dispatch(Action.RemoveVoter(voter.email)) } title="Remove"></Button>
    </View>
  </View>
}