@react.component
let make = (~election:Election.t, ~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  // TODO: Refactor by State.getAccount(state, election.ownerPublicKey)
  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  })

  <>
    <Header title=Election.name(election) />

    <Election_Show_GoToNextVersion electionId />
    //<Election_Show_Title election />

    // TODO: Election_Show_Ballot
    { if Election.description(election) != "" {
      <List.Item title=Election.description(election) />
    } else { <></> } }
    <Election_Show_Choices electionId />

    { if Option.isSome(election.result) {
      <Election_Show_ResultChart electionId />
    } else {
      <Election_Show_Choices electionId />
    } }

    { if Option.isNone(election.result) {
      if Option.isSome(orgId) {
        <>
          <Title style=X.styles["title"]>
            { t(."election.show.admin") -> React.string }
          </Title>

          <Election_Show_AddByEmailButton electionId />
          <Election_Show_CreateInviteButton electionId />

          <Button mode=#outlined onPress={_ =>
            Core.Election.tally(~electionId)(state, dispatch)
          }>
            { t(."election.show.closeAndTally") -> React.string }
          </Button>
        </>
        } else {
          <Title style=X.styles["title"]>
            { t(."election.show.notAdmin") -> React.string }
          </Title>
        }
      } else { <></> }
    }

    <Election_Show_Infos electionId />
  </>
}
