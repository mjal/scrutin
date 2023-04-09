@react.component
let make = (~electionId) => {
  let (state, _) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let election = State.getElection(state, electionId)

  <List.Section title=t(."election.show.choices")>
  {
    Array.mapWithIndex(Election.choices(election), (i, name) => {
      <List.Item title=name key=Int.toString(i) />
    }) -> React.array
  }
  </List.Section>
}
