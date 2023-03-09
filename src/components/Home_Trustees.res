@react.component
let make = () => {
  let (state, _dispatch) = Context.use()

  <List.Section title="Trustees">
    { Array.map(state.trustees, (trustee) => {
      let privkey = Belenios.Trustees.Privkey.to_str(trustee.privkey)
      let pubkey  = Belenios.Trustees.pubkey(trustee.trustees)
      <List.Item title=pubkey description=privkey key=pubkey/>
    }) -> React.array }
    <Button mode=#outlined onPress={_ => Trustee.clear()}>
      { "Clear" -> React.string }
    </Button>
  </List.Section>
}

