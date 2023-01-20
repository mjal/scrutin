open ReactNative

@react.component
let make = (~voter: Voter.t) => {
  let (_, dispatch) = State.useContextReducer()

  <View style=X.styles["row"]>
    <View style=X.styles["col"]>
    <Text>{voter.email -> React.string}</Text>
    </View>
    <View style=X.styles["col"]>
      <Button color=Color.rosybrown onPress={_ => dispatch(Action.RemoveVoter(voter.email)) } title="Remove"></Button>
    </View>
  </View>
}