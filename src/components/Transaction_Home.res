module Item = {
  @react.component
  let make = (~tx : Transaction.t) => {
    let (_state, dispatch) = Context.use()
    let { t } = ReactI18next.useTranslation()

    let description = switch tx.type_ {
    | #election => "Election"
    | #ballot   => "Ballot"
    | #tally    => "Tally"
    }

    let onPress = _ => {
      switch tx.type_ {
      | #election => dispatch(Navigate(Election_Show(tx.contentHash)))
      | #ballot   => dispatch(Navigate(Ballot_Show(tx.contentHash)))
      | #tally    =>
        let tally = Transaction.SignedTally.unwrap(tx)
        dispatch(Navigate(Election_Show(tally.electionId)))
      }
    }

    <Card>
      <List.Item key=tx.contentHash title="type" description onPress />
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

  <List.Section title=title=t(."transactions.title")>

    { Array.map(state.txs, (tx) =>
      <Item tx key=tx.contentHash />
    ) -> React.array }

    <X.Title>{ "-" -> React.string }</X.Title>

    <Button mode=#contained onPress=clear>
      { t(."transactions.clear") -> React.string }
    </Button>
  </List.Section>
}
