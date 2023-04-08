@react.component
let make = () => {
  let (state, _dispatch) = Context.use()
  let { t } = ReactI18next.useTranslation()

  <List.Section title=t(."trustees.title")>
    { Array.map(state.trustees, (trustee) => {
      let privkey = Belenios.Trustees.Privkey.to_str(trustee.privkey)
      let pubkey  = Belenios.Trustees.pubkey(trustee.trustees)
      <List.Item title=pubkey description=privkey key=pubkey/>
    }) -> React.array }
    <Button mode=#outlined onPress={_ => Trustee.clear()}>
      { t(."trustees.clear") -> React.string }
    </Button>
  </List.Section>
}

