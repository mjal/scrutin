@react.component
let make = () => {
  let (_state, dispatch) = Context.use()

  <List.Section title="Internals" style=X.styles["margin-x"]>
    <List.Item title="Identities"
      onPress={_ => dispatch(Navigate(Home_Identities))}
    />
    <List.Item title="Trustees"
      onPress={_ => dispatch(Navigate(Home_Trustees))}
    />
    <List.Item title="Transactions"
      onPress={_ => dispatch(Navigate(Home_Transactions))}
    />
  </List.Section>
}
