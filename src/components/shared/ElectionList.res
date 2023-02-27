/*
module ElectionLink = {
  @react.component
  let make = (~election : Election.t) => {
    let (_, dispatch) = Context.use()

    let uuid = election.uuid -> Option.getExn

    <List.Item
      title=election.name
      left={_ => <List.Icon icon=Icon.name("vote") />}
      right={_ => <Text>{uuid -> React.string}</Text>}
      onPress={_ => dispatch(Action.Navigate(Route.ElectionShow(uuid)))}
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
          <ElectionLink election key=Option.getWithDefault(election.uuid, "") />
        })
        -> React.array
      }
    </List.Section>
  }
}
*/
