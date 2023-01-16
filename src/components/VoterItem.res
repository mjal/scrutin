open ReactNative

@react.component
let make = (~voter: Voter.t) => {
  let (_, dispatch) = State.useContextReducer()

  <View style=shared_styles["row"]>
    <View style=shared_styles["col"]>
    <Text>{voter.email->rs}</Text>
    </View>
    <View style=shared_styles["col"]>
      <Button color=Color.rosybrown onPress={_ => dispatch(Action.RemoveVoter(voter.email)) } title="Remove"></Button>
    </View>
  </View>
}