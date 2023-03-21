@react.component
let make = (~contentHash) => {
  let (state, dispatch) = Context.use()
  let (showAdvanced, setShowAdvanced) = React.useState(_ => false)

  let ballot = State.getBallot(state, contentHash)
  let ciphertext = Option.getWithDefault(ballot.ciphertext, "")

    <List.Section title="Ballot">

      <List.Item title="Election" description=ballot.electionTx
        onPress={_ => dispatch(Navigate(Election_Show(ballot.electionTx)))}
      />

      <Button mode=#outlined onPress={_ => setShowAdvanced(b => !b)}>
        { (showAdvanced ? "Hide advanced" : "Show advanced") -> React.string }
      </Button>

      { if showAdvanced {
      <>
        <List.Item title="Event Hash" description=contentHash />

        <List.Item title="Election" description=ballot.electionTx
          onPress={_ => dispatch(Navigate(Election_Show(ballot.electionTx)))}
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

      <Ballot_New ballotTx=contentHash />

    </List.Section>
}
