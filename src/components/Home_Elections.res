module Election = {
  @react.component
  let make = (~eventHash, ~election:Election.t) => {
    let (_state, dispatch) = Context.use()
    let electionParams = Belenios.Election.parse(election.params)
    let show = _ => dispatch(Navigate(Election_Show(eventHash)))

    <Card>
      <Card.Content>
        <List.Section title=eventHash>

          <List.Item title="Name"
            description=electionParams.name
            onPress=show />

          <List.Item title="Description"
            description=electionParams.description
            onPress=show />

          <List.Item title="Administrator"
            description=election.ownerPublicKey
            onPress={_ =>
              dispatch(Navigate(Identity_Show(election.ownerPublicKey)))} />

        </List.Section>
      </Card.Content>
      <Card.Actions>

        <Button onPress=show>
          {"Show"->React.string}
        </Button>

      </Card.Actions>
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  <>
    <X.Title>{ "Elections" -> React.string }</X.Title>
    { state.cache.elections
      -> Map.String.toArray
      -> Array.map(((eventHash, election)) => {
        <Election eventHash election />
    }) -> React.array }
    <Button mode=#contained onPress={_ => dispatch(Navigate(Election_New))}>
      { "New election" -> React.string }
    </Button>
  </>
}