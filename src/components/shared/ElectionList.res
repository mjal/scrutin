open! Paper

module ElectionLink = {
  @react.component
  let make = (~election : Election.t) => {
    let (_, dispatch) = Context.use()

    <List.Item
      title=election.name
      left={_ => <List.Icon icon=Icon.name("vote") />}
      right={_ => <Text>{election.id -> Int.toString -> React.string}</Text>}
      onPress={_ => dispatch(Action.Navigate(Route.ElectionShow(election.id)))}
    />
  }
}

@react.component
let make = (~title, ~elections : array<Election.t>, ~loading=false) => {
  if loading {
    <ActivityIndicator />
  } else {
    <List.Section title style=X.styles["margin-x"]>
      {
        Array.map(elections, (election) => {
          <ElectionLink election key=Int.toString(election.id) />
        })
        -> React.array
      }
    </List.Section>
  }
}