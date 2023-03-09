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

    <Card>
      <List.Item
        key=tx.eventHash
        title="type"
        description=tx.eventType
        onPress
      />
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  let clear = _ => {
    Transaction.clear()
    dispatch(Init)
  }

  <List.Section title="Transactions">

    { Array.map(state.txs, (tx) =>
      <Item tx key=tx.eventHash />
    ) -> React.array }

    <X.Title>{ "-" -> React.string }</X.Title>

    <Button mode=#contained onPress=clear>
      { "Clear" -> React.string }
    </Button>
  </List.Section>
}
