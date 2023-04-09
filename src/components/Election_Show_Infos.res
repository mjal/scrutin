@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let election = State.getElectionExn(state, electionId)
  let (showAdvanced, setShowAdvanced) = React.useState(_ => false)
  let (showBallots, setShowBallots) = React.useState(_ => false)

  let ballots = Map.String.keep(state.cachedBallots, (_id, ballot) =>
    ballot.electionId == electionId
  ) -> Map.String.toArray

  let nbBallots = Array.length(ballots)

  <>
    <Button mode=#outlined onPress={_ => setShowAdvanced(b => !b)}>
      { (if (showAdvanced) {
        t(."election.show.hideAdvanced")
      } else {
        t(."election.show.showAdvanced")
      }) -> React.string }
    </Button>

    { if showAdvanced {
    <>
      <List.Item title=t(."election.show.id") description=electionId />

      {
        let onPress = _ =>
          dispatch(Navigate(Identity_Show(election.ownerPublicKey)))
        <List.Item title=t(."election.show.ownerPublicKey") onPress
          description=election.ownerPublicKey />
      }

      <List.Item
        title=t(."election.show.params")
        description=election.params />

      <List.Item
        title=t(."election.show.trustees")
        description=election.trustees />
    </>
    } else { <></> } }

    <Button mode=#outlined onPress={_ => setShowBallots(b => !b)}>
      { (if (showBallots) {
        t(."election.show.hideBallots")
      } else {
        t(."election.show.showBallots")
      }) -> React.string }
    </Button>

    { if showBallots {
      <List.Section title=`${nbBallots -> Int.toString} ballots`>
      {
        Array.map(ballots, ((id, _ballot)) => {
          <List.Item title=`Ballot ${id}`
            key=id
            onPress={_ => dispatch(Navigate(Ballot_Show(id)))}
          />
        }) -> React.array
      }
      </List.Section>
    } else { <></> } }

  </>
}
