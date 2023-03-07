module Item = {
  @react.component
  let make = (~tx : Transaction.t) => {
    let (_state, dispatch) = Context.use()
    let onPress = _ => {
      switch tx.eventType {
      | "election" => dispatch(Navigate(Election_Show(tx.eventHash)))
      | "ballot"   => dispatch(Navigate(Ballot_Show(tx.eventHash)))
      | _ => Js.Exn.raiseError("Unknown transaction type")
      }
    }

    <List.Item
      key=tx.eventHash
      title=("0x" ++ tx.eventHash)
      onPress
    />
  }
}

@react.component
let make = () => {
  let (state, _dispatch) = Context.use()

  <List.Section title="Transactions">
    { Array.map(state.txs, (tx) => <Item tx />) -> React.array }
    <Button mode=#outlined onPress={_ => Transaction.clear()}>
      { "Clear" -> React.string }
    </Button>
  </List.Section>
}
