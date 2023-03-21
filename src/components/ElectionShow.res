@react.component
let make = (~electionId) => {
  let (state, dispatch) = Context.use()
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

  let progress  = `${nbBallotsWithCiphertext -> Int.toString} / ${nbBallots -> Int.toString}`

  let tally = Map.String.findFirstBy(state.cached_tallies, (_id, tally) =>
    tally.electionId == electionId
  ) -> Option.map(((_id, tally)) => tally)

  <>
    <List.Section title="">

      <List.Item
        title=Election.name(election)
        description=Election.description(election) />

      <List.Section title="Choix">
      { Array.mapWithIndex(Election.choices(election), (i, name) => {
        <List.Item title=name key=Int.toString(i) />
      }) -> React.array }
      </List.Section>

      <List.Item title="Status"
        description={Option.isSome(tally) ? "Finished" : "En cours"} />

      <Button mode=#outlined onPress={_ => setShowAdvanced(b => !b)}>
        { (showAdvanced ? "Hide advanced" : "Show advanced") -> React.string }
      </Button>

      { if showAdvanced {
      <>
        <List.Item title="Id/Hash" description=electionId />

        {
          let onPress = _ =>
            dispatch(Navigate(Identity_Show(election.ownerPublicKey)))
          <List.Item title="Owner Public Key" onPress
            description=election.ownerPublicKey />
        }

        <List.Item title="Params" description=election.params />

        <List.Item title="Trustees" description=election.trustees />
      </>
      } else { <></> } }

      <List.Item title="Ballot transactions"
        description=progress />

      <Button mode=#outlined onPress={_ => setShowBallots(b => !b)}>
        { (showBallots ? "Hide ballots" : "Show ballots") -> React.string }
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
      let result = Option.getExn(tally).result
      let data = Belenios.Election.scores(result)
      <>
        <List.Item title="Result" description=Option.getExn(tally).result />
        <ElectionShow__ResultChart data />
      </>
    } else { if Option.isSome(orgId) {
    <>
      <Title style=X.styles["title"]>
        { "You are admin" -> React.string }
      </Title>

      <ElectionShow__AddByEmailButton electionId />

      <ElectionShow__AddContactButton electionId />

      <Button mode=#outlined onPress={_ =>
        Core.Election.tally(~electionId)(state, dispatch)
      }>
        { "Close election and tally" -> React.string }
      </Button>
    </>
    } else {
    <>
      <Title style=X.styles["title"]>
        { "You are not admin" -> React.string }
      </Title>
    </>
    } } }

  </>
}
