@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let election = State.getElectionExn(state, electionId)

  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  })

  <>
    { switch Map.String.get(state.cachedElectionReplacementIds, electionId) {
    | Some(replacementId) =>
      <Text
        onPress={_ => dispatch(Navigate(Election_Show(replacementId)))}
        style=Style.textStyle(~color=Color.red,())>
      { "This object version is obselete.
        Click here for the next version"
        -> React.string
      }
      </Text>
    | None => <></>
    } }

    <Election_Show_Title election />

    { if Election.description(election) != "" {
      <List.Item title=Election.description(election) />
    } else { <></> } }

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
