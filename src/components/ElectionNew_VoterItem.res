open ReactNative

@react.component
let make = (~voter: Voter.t) => {
  let (_, dispatch) = State.useContexts()

  <X.Row>
    <X.Col>
    <Text>{voter.email -> React.string}</Text>
    </X.Col>
    <X.Col>
      <Button color=Color.rosybrown onPress={_ => dispatch(Action.RemoveVoter(voter.email)) } title="Remove"></Button>
    </X.Col>
  </X.Row>
}