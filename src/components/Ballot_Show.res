@react.component
let make = (~ballotId) => {
  let (state, dispatch) = Context.use()
  let (showAdvanced, setShowAdvanced) = React.useState(_ => false)

  if Map.String.has(state.cached_ballots, ballotId) {
    let ballot = State.getBallot(state, ballotId)
    let ciphertext = Option.getWithDefault(ballot.ciphertext, "")

    <List.Section title="Ballot">

      <List.Item title="Election" description=ballot.electionId
        onPress={_ => dispatch(Navigate(Election_Show(ballot.electionId)))}
      />

      <Button mode=#outlined onPress={_ => setShowAdvanced(b => !b)}>
        { (showAdvanced ? "Hide advanced" : "Show advanced") -> React.string }
      </Button>

      { if showAdvanced {
      <>
        <List.Item title="Event Hash" description=ballotId />

        <List.Item title="Election" description=ballot.electionId
          onPress={_ => dispatch(Navigate(Election_Show(ballot.electionId)))}
        />

        <List.Item title="Previous transaction"
          description=Option.getWithDefault(ballot.previousTx, "")
        />

        <List.Item title="Voter" description=ballot.voterPublicKey
          onPress={_ => 
            dispatch(Navigate(Identity_Show(ballot.voterPublicKey)))
          } />

        <List.Item title="Ciphertext" description=ciphertext
          onPress={_ => dispatch(Navigate(Election_Show(ciphertext)))}
        />
      </>
      } else { <></> } }

      <Ballot_New ballotId />

    </List.Section>
  } else {
    <Text>{ "Loading" -> React.string }</Text>
  }
}
