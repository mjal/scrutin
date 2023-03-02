module Election = {
  @react.component
  let make = (~tx : Transaction.t, ~election : Election.t) => {
    <Card>
      <Card.Content>
        <Title>{ tx.eventHash -> React.string }</Title>
        <Text>{ tx.eventType -> React.string}</Text>
        <Text>{ election.params -> React.string}</Text>
        <Text>{ election.trustees -> React.string}</Text>
        <Text>{ election.ownerPublicKey -> React.string}</Text>
      </Card.Content>
      <Card.Actions>
        <Button>{"Cancel"->React.string}</Button>
        <Button>{"Ok"->React.string}</Button>
      </Card.Actions>
    </Card>
  }
}

@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  <>
    <X.Title>{ "Transactions" -> React.string }</X.Title>
    <>{ Array.map(state.txs, (tx) => {
      switch tx.eventType {
      | "election" =>
        let election = Transaction.SignedElection.unwrap(tx)
        <Election tx election key=tx.eventHash />
      | _ =>
        <Text>{ "Unknown event type" -> React.string }</Text>
      }
    }) -> React.array }</>
    <List.Section title="" style=X.styles["margin-x"]>
    { Array.map(state.txs, (tx) => {
      <List.Item
        key=tx.eventHash
        title=("0x" ++ tx.eventHash)
      />
    }) -> React.array }
    </List.Section>
  </>
}
