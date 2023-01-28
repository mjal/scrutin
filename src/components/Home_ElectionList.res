open ReactNative
open! Paper

let styles = {
  open Style
  StyleSheet.create({
    "grey": textStyle(~color="grey", ())
  })
}

let electionLink = (election : Election.t) => {
  let (_, dispatch) = State.useContextReducer()

  <List.Item
    title=election.name
    left={_ => <List.Icon icon=Icon.name("vote") />}
    onPress={_ => dispatch(Action.Navigate(Route.ElectionShow(election.id)))}
  />
}


@react.component
let make = () => {
  let (state, _dispatch) = State.useContextReducer()

  if state.elections_loading {
    <ActivityIndicator />
  } else {
    <List.Section title="Elections en cours">
      {
        state.elections
        -> Js.Array2.map(electionLink)
        -> React.array
      }
    </List.Section>
  }
}