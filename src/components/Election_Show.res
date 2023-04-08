@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let (showAdvanced, setShowAdvanced) = React.useState(_ => false)
  let (showBallots, setShowBallots) = React.useState(_ => false)

  let election = State.getElection(state, electionId)

  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  })

  let ballots = Map.String.keep(state.cached_ballots, (_id, ballot) =>
    ballot.electionId == electionId
  ) -> Map.String.toArray

  let nbBallots = Array.length(ballots)

  let nbBallotsWithCiphertext = Array.keep(ballots, ((_id, ballot)) => {
    Option.isSome(ballot.ciphertext)
  }) -> Array.length

  let ballotEvents  = `${nbBallotsWithCiphertext -> Int.toString} / ${nbBallots -> Int.toString}`

  let tally = Map.String.findFirstBy(state.cached_tallies, (_id, tally) =>
    tally.electionId == electionId
  ) -> Option.map(((_id, tally)) => tally)

  let statusDescription = switch (tally) {
    | Some(_tally) => t(."election.show.statusFinished")
    | None => t(."election.show.statusInProgress")
  }

  <>
    <List.Section title="">

      <List.Item
        title=Election.name(election)
        description=Election.description(election) />

      { if Option.isSome(tally) {
        <Election_Show_ResultChart electionId />
      } else {
        <List.Section title=t(."election.show.choices")>
        { Array.mapWithIndex(Election.choices(election), (i, name) => {
          <List.Item title=name key=Int.toString(i) />
        }) -> React.array }
        </List.Section>
      } }

      <List.Item title=t(."election.show.status")
        description=statusDescription />

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

      <List.Item title=t(."election.show.ballotEvents")
        description=ballotEvents />

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

    </List.Section>

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

  </>
}
