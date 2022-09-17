open Helper
open ReactNative;
open Paper;

@react.component
let make = (~name, ~dispatch) => {
  <List.Item title=name
    left={_ => <List.Icon icon=Icon.name("account-tie") />} 
    right={_ =>
      <Button onPress={_ => dispatch(Action.RemoveCandidate(name)) }>
        <List.Icon icon=Icon.name("delete") />
      </Button>
    }
  />
}
