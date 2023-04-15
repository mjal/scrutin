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

    { switch election.result {
    | Some(_result) => <ElectionResultChart electionId />
    | None => <ElectionShowChoices electionId />
    } }

    { if Option.isNone(election.result) {
      if Option.isSome(orgId) {
        <>
          <S.Title>
            { t(."election.show.admin") -> React.string }
          </S.Title>

          <ElectionShowAddByEmailButton electionId />
          <ElectionInviteButton electionId />

          <Button mode=#outlined onPress={_ =>
            Core.Election.tally(~electionId)(state, dispatch)
          }>
            { t(."election.show.closeAndTally") -> React.string }
          </Button>
        </>
        } else {
          <S.Title>
            { t(."election.show.notAdmin") -> React.string }
          </S.Title>
        }
      } else { <></> }
    }

    <ElectionInfos electionId />
  </>
}
