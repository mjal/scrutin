open! Paper;

@react.component
let make = (~index, ~choice: Choice.t) => {
  let (_, dispatch) = Context.use()

  <List.Item
    title=choice.name
    left={_ => <List.Icon icon=Icon.name("vote") />}
    onPress={_ => ()}
    right={_ =>
      <Button onPress={_ => dispatch(Action.Election_RemoveChoice(index))}>
        <List.Icon icon=Icon.name("delete") />
      </Button>
    }
  />
}
