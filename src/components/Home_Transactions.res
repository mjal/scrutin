@react.component
let make = () => {
  let (state, _dispatch) = Context.use()

  <List.Section title="Transactions">
    { Array.map(state.txs, (tx) => {
//    switch tx.eventType {
//    | "election" =>
      <List.Item
        key=tx.eventHash
        title=("0x" ++ tx.eventHash)
      />
    }) -> React.array }
    <Button mode=#outlined onPress={_ => Transaction.clear()}>
      { "Clear" -> React.string }
    </Button>
  </List.Section>
}
