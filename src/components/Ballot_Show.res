@react.component
let make = (~eventHash) => {
  let (state, dispatch) = Context.use()
  let ballot = Map.String.getExn(state.cache.ballots, eventHash)

  let ciphertext = Option.getWithDefault(ballot.ciphertext, "")

    <List.Section title="Ballot">
      <List.Item title="Event Hash" description=eventHash />

      <List.Item title="Election" description=ballot.electionTx
        onPress={_ => dispatch(Navigate(Election_Show(ballot.electionTx)))}
      />

      <List.Item title="Previous transaction"
        description=Option.getWithDefault(ballot.previousTx, "")
      />

      {
        Array.mapWithIndex(ballot.owners, (i, publicKey) => {
          let onPress = _ => dispatch(Navigate(Identity_Show(publicKey)))
          let title   = `Public Key ${i -> Int.toString}`
          <List.Item title onPress description=publicKey />
        }) -> React.array
      }

      <List.Item title="Ciphertext" description=ciphertext
        onPress={_ => dispatch(Navigate(Election_Show(ciphertext)))}
      />

      <Election_Booth ballotTx=eventHash />

    </List.Section>
}
