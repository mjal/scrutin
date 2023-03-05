@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  switch state.route {
  | Home_Elections =>
    <>
      <X.Title>{ "Elections" -> React.string }</X.Title>
      { state.cache.elections
        -> Map.String.toArray
        -> Array.map(((eventHash, _election)) => {
        <List.Item
          onPress={_ => dispatch(Navigate(Election_Show(eventHash)))}
          key=eventHash
          title=("0x" ++ eventHash)
        />
      }) -> React.array }
      <Button mode=#contained onPress={_ => dispatch(Navigate(Election_New))}>
        { "New election" -> React.string }
      </Button>
    </>
  | Home_Identities => <Home_Identities />
  | Home_Transactions => <Home_Transactions />
  | _ =>
    <Text>{"Unknown route"->React.string}</Text>
  }
}
