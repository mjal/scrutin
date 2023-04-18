module Election = {
  @react.component
  let make = (~id, ~election:Election.t) => {
    let (_state, dispatch) = StateContext.use()

    let electionParams = Belenios.Election.parse(election.params)
    let name = electionParams.name == "" ? "Unnamed" : electionParams.name

    <Card style=S.marginY(8.0)>
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
  let (state, _dispatch) = StateContext.use()
  let { t } = ReactI18next.useTranslation()

  <>
    <Header title=t(."search.header.title") />

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
  </>
}
