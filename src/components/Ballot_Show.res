@react.component
let make = (~ballotId) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let (showAdvanced, setShowAdvanced) = React.useState(_ => false)

  let ballot = State.getBallot(state, ballotId)
  let ciphertext = Option.getWithDefault(ballot.ciphertext, "")

  <List.Section title=t(."ballot.show.title")>

    <List.Item title=t(."ballot.show.election") description=ballot.electionId
      onPress={_ => dispatch(Navigate(Election_Show(ballot.electionId)))}
    />

    <Button mode=#outlined onPress={_ => setShowAdvanced(b => !b)}>
      { (showAdvanced ? "Hide advanced" : "Show advanced") -> React.string }
    </Button>

    { if showAdvanced {
    <>
      <List.Item title=t(."ballot.show.eventHash") description=ballotId />

      <List.Item title=t(."ballot.show.election") description=ballot.electionId
        onPress={_ => dispatch(Navigate(Election_Show(ballot.electionId)))}
      />

      <List.Item title=t(."ballot.show.previousId")
        description=Option.getWithDefault(ballot.previousTx, "")
      />

      <List.Item title=t(."ballot.show.voter") description=ballot.voterPublicKey
        onPress={_ => 
          dispatch(Navigate(Identity_Show(ballot.voterPublicKey)))
        } />

      <List.Item title=t(."ballot.show.ciphertext") description=ciphertext
        onPress={_ => dispatch(Navigate(Election_Show(ciphertext)))}
      />
    </>
    } else { <></> } }

    <Ballot_New ballotId />

  </List.Section>
}
