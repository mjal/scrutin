@react.component
let make = (~publicKey) => {
  let (state, dispatch) = Context.use()

  <>
    <List.Section title="Identity">

      <List.Item title="Public Key" description=publicKey />

      <List.Accordion title="My Elections (as admin)">
        {
          state.cache.elections
          -> Map.String.keep((_eventHash, election) =>
            election.ownerPublicKey == publicKey
          )
          -> Map.String.toArray
          -> Array.map(((eventHash, _election)) => {
            <List.Item title=eventHash
              onPress={_ => dispatch(Navigate(Election_Show(eventHash)))}
            />
          })
          -> React.array
        }
      </List.Accordion>

    </List.Section>
  </>
}