@react.component
let make = (~publicKey) => {
  let (state, dispatch) = Context.use()
  //let election = Map.String.getExn(state.cache.elections, eventHash)

  <>
    <Title>{"Identity"->React.string}</Title>
    <Text>{ publicKey -> React.string }</Text>
    <Title>{"My Elections (as admin)"->React.string}</Title>
    {
      state.cache.elections
      -> Map.String.keep((eventHash, election) => {
        election.ownerPublicKey == publicKey
      })
      -> Map.String.toArray
      -> Array.map(((eventHash, election)) => {
        <Text
          onPress={_ => dispatch(Navigate(Election_Show(eventHash)))}
        >
          { eventHash -> React.string }
        </Text>
      }) -> React.array
    }
    <Title>{"My Elections (as voter)"->React.string}</Title>
    <Title>{"My Elections (as trustee)"->React.string}</Title>
    <Title>{"Elections (as voter)"->React.string}</Title>
  </>
}