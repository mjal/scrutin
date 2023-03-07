@react.component
let make = (~publicKey) => {
  let (state, dispatch) = Context.use()

  let ballots = state.cache.ballots
    -> Map.String.keep((_eventHash, ballot) =>
      Array.some(ballot.owners, (id) => id == publicKey)
    )
    -> Map.String.toArray

  let elections = state.cache.elections
    -> Map.String.keep((_eventHash, election) =>
      election.ownerPublicKey == publicKey
    )
    -> Map.String.toArray

  <>
    <List.Section title="Identity">

      <List.Item title="Public Key" description=publicKey />

      <List.Accordion title="Elections">
      {
        Array.map(elections, ((eventHash, _election)) => {
          <List.Item title=eventHash key=eventHash
            onPress={_ => dispatch(Navigate(Election_Show(eventHash)))}
          />
        }) -> React.array
      }
      </List.Accordion>

      <List.Accordion title="Ballots">
      {
        Array.map(ballots, ((eventHash, _ballot)) => {
          <List.Item title=eventHash key=eventHash
            onPress={_ => dispatch(Navigate(Ballot_Show(eventHash)))}
          />
        }) -> React.array
      }
      </List.Accordion>

    </List.Section>
  </>
}
