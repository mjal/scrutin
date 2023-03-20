module Election = {
  @react.component
  let make = (~eventHash, ~election:Election.t) => {
    let (_state, dispatch) = Context.use()
    Js.log(eventHash)
    let electionParams = Belenios.Election.parse(election.params)
    let show = _ => dispatch(Navigate(Election_Show(eventHash)))

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

  Js.log(state.txs)
  Js.log(state.cached_elections)
  <>
    <X.Title>{ "-" -> React.string }</X.Title>
    <Button mode=#contained onPress={_ => dispatch(Navigate(Election_New))}>
      { "Creer une nouvelle election" -> React.string }
    </Button>
    <X.Title>{ "-" -> React.string }</X.Title>
    { state.cached_elections
      -> Map.String.toArray
      -> Array.map(((eventHash, election)) => {
        <Election eventHash election key=eventHash />
    }) -> React.array }
    <X.Title>{ "-" -> React.string }</X.Title>
  </>
}
