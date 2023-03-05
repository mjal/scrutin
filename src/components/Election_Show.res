@react.component
let make = (~eventHash) => {
  let (state, dispatch) = Context.use()
  let election = Map.String.getExn(state.cache.elections, eventHash)

  <>
    <Title>{"Owner"->React.string}</Title>
    {
      let onPress = _ =>
        dispatch(Navigate(Identity_Show(election.ownerPublicKey)))
      <Text onPress>{ election.ownerPublicKey -> React.string }</Text>
    }
    <Title>{"Params"->React.string}</Title>
    <Text>{ election.params -> React.string }</Text>
    <Title>{"Trustees"->React.string}</Title>
    <Text>{ election.trustees -> React.string }</Text>

    <Election_Booth election />
  </>
}