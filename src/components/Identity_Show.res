@react.component
let make = (~publicKey) => {
  let (state, dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  let identity = Array.getBy(state.ids, (id) => {
    id.hexPublicKey == publicKey
  })
  let secretKey =
    Option.flatMap(identity, (identity) => identity.hexSecretKey)
    -> Option.getWithDefault("")

  let ballots = state.cachedBallots
    -> Map.String.keep((_eventHash, ballot) =>
      ballot.voterPublicKey == publicKey
    )
    -> Map.String.toArray

  let elections = state.cachedElections
    -> Map.String.keep((_eventHash, election) =>
      election.ownerPublicKey == publicKey
    )
    -> Map.String.toArray

  <>
    <List.Section title=t(."identity.show.title")>

      <List.Item title=t(."identity.show.publicKey") description=publicKey />

      <List.Item title=t(."identity.show.secretKey") description=secretKey />

      <List.Accordion title=t(."identity.show.elections")>
      {
        Array.map(elections, ((eventHash, _election)) => {
          <List.Item title=eventHash key=eventHash
            onPress={_ => dispatch(Navigate(Election_Show(eventHash)))}
          />
        }) -> React.array
      }
      </List.Accordion>

      <List.Accordion title=t(."identity.show.ballots")>
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
