@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let election = State.getElection(state, electionId)

  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  })

  let tally = Map.String.findFirstBy(state.cached_tallies, (_id, tally) =>
    tally.electionId == electionId
  ) -> Option.map(((_id, tally)) => tally)

  <>
    <Election_Show_Title election tally />

    { if Election.description(election) != "" {
      <List.Item title=Election.description(election) />
    } else { <></> } }

    { if Option.isSome(tally) {
      <Election_Show_ResultChart electionId />
    } else {
      <Election_Show_Choices electionId />
    } }

    { if Option.isSome(tally) {
      //<Election_Show_ResultChart electionId />
      <></>
    } else { if Option.isSome(orgId) {
    <>
      <Title style=X.styles["title"]>
        { t(."election.show.admin") -> React.string }
      </Title>

      <Election_Show_AddByEmailButton electionId />

      //<Election_Show_AddContactButton electionId />

      <Button mode=#outlined onPress={_ =>
        Core.Election.tally(~electionId)(state, dispatch)
      }>
        { t(."election.show.closeAndTally") -> React.string }
      </Button>
    </>
    } else {
    <>
      <Title style=X.styles["title"]>
        { t(."election.show.notAdmin") -> React.string }
      </Title>
    </>
    } } }

    <Election_Show_Infos electionId />
  </>
}
