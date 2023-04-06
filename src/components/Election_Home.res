module Election = {
  @react.component
  let make = (~id, ~election:Election.t) => {
    let (_state, dispatch) = Context.use()
    let { t } = ReactI18next.useTranslation()

    let electionParams = Belenios.Election.parse(election.params)
    let show = _ => dispatch(Navigate(Election_Show(id)))

    <Card>
      <Card.Content>
        <List.Section
          title=t(."election.home.item.title")>

          <List.Item
            title=t(."election.home.item.name")
            description=electionParams.name />

          <List.Item
            title=t(."election.home.item.description")
            description=electionParams.description />

        </List.Section>
      </Card.Content>

      <Card.Actions>

        <Button mode=#contained onPress=show>
          { t(."election.home.item.go") -> React.string }
        </Button>

      </Card.Actions>
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  <>
    <X.Title>{ "-" -> React.string }</X.Title>
    <Button mode=#contained onPress={_ => dispatch(Navigate(Election_New))}>
      { t(."election.home.create") -> React.string }
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
