module Election = {
  @react.component
  let make = (~id, ~election:Election.t) => {
    let (_state, dispatch) = Context.use()
    let electionParams = Belenios.Election.parse(election.params)
    let show = _ => dispatch(Navigate(Election_Show(id)))

    <Card>
      <Card.Content>
        <List.Section title="Election en cours">

          <List.Item title="Name"
            description=electionParams.name />

          <List.Item title="Description"
            description=electionParams.description />

          //<List.Item title="Administrator"
          //  description=election.ownerPublicKey
          ///>

        </List.Section>
      </Card.Content>

      <Card.Actions>

        <Button mode=#contained onPress=show>
          {"Go"->React.string}
        </Button>

      </Card.Actions>
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  <>
    <X.Title>{ "-" -> React.string }</X.Title>
    <Button mode=#contained onPress={_ => dispatch(Navigate(Election_New))}>
      { "Creer une nouvelle election" -> React.string }
    </Button>
    <X.Title>{ "-" -> React.string }</X.Title>
    { state.cached_elections
      -> Map.String.toArray
      -> Array.map(((id, election)) => {
        <Election id election key=id />
    }) -> React.array }
    <X.Title>{ "-" -> React.string }</X.Title>
  </>
}
