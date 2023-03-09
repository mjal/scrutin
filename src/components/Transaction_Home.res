module Item = {
  @react.component
  let make = (~tx : Transaction.t) => {
    let (_state, dispatch) = Context.use()

    let description = switch tx.eventType {
    | #election => "Election"
    | #ballot   => "Ballot"
    }

    let onPress = _ => {
      switch tx.eventType {
      | #election => dispatch(Navigate(Election_Show(tx.eventHash)))
      | #ballot   => dispatch(Navigate(Ballot_Show(tx.eventHash)))
      }
    }

    <Card>
      <List.Item key=tx.eventHash title="type" description onPress />
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  let clear = _ => {
    Transaction.clear()
    dispatch(Reset)
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
