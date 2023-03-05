@react.component
let make = () => {
  let (state, dispatch) = Context.use()

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
}