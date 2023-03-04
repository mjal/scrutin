@react.component
let make = (~eventHash) => {
  let (state, _) = Context.use()
  let election = Map.String.getExn(state.cache.elections, eventHash)

  <>
    <Title>{"Owner"->React.string}</Title>
    <Text>{ election.ownerPublicKey -> React.string }</Text>
    <Title>{"Params"->React.string}</Title>
    <Text>{ election.params -> React.string }</Text>
    <Title>{"Trustees"->React.string}</Title>
    <Text>{ election.trustees -> React.string }</Text>

    <Button mode=#contained>{"Voter" -> React.string}</Button>

    <Election_Booth election />
  </>
}