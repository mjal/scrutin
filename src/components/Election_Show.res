@react.component
let make = (~eventHash) => {
  let (state, dispatch) = Context.use()
  let election = Map.String.getExn(state.cache.elections, eventHash)

  let publicKey = election.ownerPublicKey

  <>
    <List.Section title="Election">

      <List.Item title="Event Hash" description=eventHash />

      {
        let onPress = _ => dispatch(Navigate(Identity_Show(publicKey)))
        <List.Item title="Owner Public Key" onPress description=publicKey />
      }

      <List.Item title="Params" description=election.params />

      <List.Item title="Trustees" description=election.trustees />

    </List.Section>

    <Divider />

    <Election_Booth election />
  </>
}