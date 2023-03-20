@react.component
let make = (~contentHash) => { // Rename contentHash to id
  let (state, dispatch) = Context.use()
  let (showAdvanced, setShowAdvanced) = React.useState(_ => false)
  let (showBallots, setShowBallots) = React.useState(_ => false)
  let election = Map.String.getExn(state.cached_elections, contentHash)
  let publicKey = election.ownerPublicKey

  let orgId = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == election.ownerPublicKey
  })

  let ballots = Map.String.keep(state.cached_ballots, (_id, ballot) =>
    ballot.electionTx == contentHash
  ) -> Map.String.toArray

  /*
  let ballots =
    state.txs
    -> Array.keep((tx) => tx.type_ == #ballot)
    -> Array.keep((tx) => {
      let ballot = Transaction.SignedBallot.unwrap(tx)
      ballot.electionTx == contentHash
    })
  */

  let nbBallots = Array.length(ballots)

  let nbBallotsWithCiphertext = Array.keep(ballots, ((_id, ballot)) => {
    Option.isSome(ballot.ciphertext)
  }) -> Array.length

  let progress  = `${nbBallotsWithCiphertext -> Int.toString} votes / ${nbBallots -> Int.toString}`

  let tally = Map.String.findFirstBy(state.cached_tallies, (_id, tally) =>
    tally.electionTx == contentHash
  ) -> Option.map(((_id, tally)) => tally)

  <>
    <List.Section title="Election">

      <List.Item title="Name" description=Election.name(election) />

      <List.Item title="Description"
        description=Election.description(election) />

      <List.Item title="Status"
        description={Option.isSome(tally) ? "Finished" : "En cours"} />

      <Button mode=#outlined onPress={_ => setShowAdvanced(b => !b)}>
        { (showAdvanced ? "Hide advanced" : "Show advanced") -> React.string }
      </Button>

      { if showAdvanced {
        <>
          <List.Item title="Event Hash" description=contentHash />

          {
            let onPress = _ => dispatch(Navigate(Identity_Show(publicKey)))
            <List.Item title="Owner Public Key" onPress description=publicKey />
          }

          <List.Item title="Params" description=election.params />

          <List.Item title="Trustees" description=election.trustees />
        </>
      } else { <></> } }

      <List.Item title="Votes"
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
      <List.Item title="Result" description=Option.getExn(tally).result />
    } else { if Option.isSome(orgId) {
    <>
      <Title style=X.styles["title"]>
        { "You are admin" -> React.string }
      </Title>

      <ElectionShow__AddByEmailButton contentHash />

      <ElectionShow__AddContactButton contentHash />

      <Button mode=#outlined onPress={_ =>
        Core.Election.tally(~electionEventHash=contentHash)(state, dispatch)
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
