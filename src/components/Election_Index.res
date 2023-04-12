module Election = {
  @react.component
  let make = (~id, ~election:Election.t) => {
    let (_state, dispatch) = Context.use()

    let electionParams = Belenios.Election.parse(election.params)
    let name = electionParams.name == "" ? "Unnamed" : electionParams.name

    <Card style=X.styles["margin-y-8"]>
      <Card.Content>
        <List.Section title="">

          <List.Item
            onPress={ _ => dispatch(Navigate(list{"elections", id})) }
            title=name
            description=electionParams.description />

        </List.Section>
      </Card.Content>
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  <>
    <X.Title>{ "-" -> React.string }</X.Title>
    <Button mode=#contained onPress={_ => dispatch(Navigate(list{"elections", "new"}))}>
      { t(."election.home.create") -> React.string }
    </Button>
    <X.Title>{ "-" -> React.string }</X.Title>
    { state.cachedElections
      -> Map.String.toArray
      -> Array.keep(((id, _election)) => {
        state.cachedElectionReplacementIds
        -> Map.String.get(id)
        -> Option.isNone
      })
      -> Array.map(((id, election)) => {
        <Election id election key=id />
    }) -> React.array }
    <X.Title>{ "-" -> React.string }</X.Title>
  </>
}
