@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  <>
    <X.Title>{ "Identités" -> React.string }</X.Title>
    <List.Section title="" style=X.styles["margin-x"]>
    { Array.map(state.ids, (id) => {
      <List.Item
        key=id.hexPublicKey
        title=("0x" ++ id.hexPublicKey)
        onPress={_ => dispatch(Navigate(Identity_Show(id.hexPublicKey)))}
      />
    }) -> React.array }
    </List.Section>
    <Button mode=#contained onPress={_ => { dispatch(Identity_Add(Identity.make())) }}>
      { "New identity" -> React.string }
    </Button>
    <Button mode=#outlined onPress={_ => Identity.clear()}>
      { "Clear identities" -> React.string }
    </Button>
  </>
}
