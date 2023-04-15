@react.component
let make = (~ballot:Ballot.t, ~ballotId) => {
  let (_state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()
  let (showAdvanced, setShowAdvanced) = React.useState(_ => false)
  let ciphertext = Option.getWithDefault(ballot.ciphertext, "")

  <List.Section title=t(."ballot.show.title")>

    <List.Item title=t(."ballot.show.election") description=ballot.electionId
      onPress={_ => dispatch(Navigate(list{"elections", ballot.electionId}))}
    />

    <Button mode=#outlined onPress={_ => setShowAdvanced(b => !b)}>
      { (showAdvanced ? "Hide advanced" : "Show advanced") -> React.string }
    </Button>

    { if showAdvanced {
    <>
      <List.Item title=t(."ballot.show.eventHash") description=ballotId />

      <List.Item title=t(."ballot.show.election") description=ballot.electionId
        onPress={_ => dispatch(Navigate(list{"elections", ballot.electionId}))}
      />

      <List.Item title=t(."ballot.show.previousId")
        description=Option.getWithDefault(ballot.previousId, "")
      />

      <List.Item title=t(."ballot.show.voter") description=ballot.voterPublicKey
        onPress={_ => 
          dispatch(Navigate(list{"identitites", ballot.voterPublicKey}))
        } />

      <List.Item title=t(."ballot.show.ciphertext") description=ciphertext />
    </>
    } else { <></> } }

    <BallotNew ballotId />

  </List.Section>
}
