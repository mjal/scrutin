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
      <Button onPress={_ => dispatch(Action.RemoveChoice(choice.name))}>
        <List.Icon icon=Icon.name("delete") />
      </Button>
    }
  />
}
