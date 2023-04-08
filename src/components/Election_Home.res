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
            onPress={ _ => dispatch(Navigate(Election_Show(id))) }
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
