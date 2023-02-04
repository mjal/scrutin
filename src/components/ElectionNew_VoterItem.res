open! Paper;

@react.component
let make = (~index, ~voter: Voter.t) => {
  let (_, dispatch) = State.useContexts()

  <List.Item
    title=voter.email
    left={_ => <List.Icon icon=Icon.name("account") />}
    onPress={_ => ()}
    right={_ =>
      <Button onPress={_ => dispatch(Action.RemoveVoter(index))}>
        <List.Icon icon=Icon.name("delete") />
      </Button>
    }
  />
}