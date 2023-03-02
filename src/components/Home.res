@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  let genIdentity = _ => {
    dispatch(Identity_Add(Identity.make()))
  }

  switch state.route {
  | Home_Elections =>
    <>
      <X.Title>{ "Elections" -> React.string }</X.Title>
      { state.cache.elections
        -> Map.String.toArray
        -> Array.map(((eventHash, _election)) => {
        <List.Item
          key=eventHash
          title=("0x" ++ eventHash)
        />
      }) -> React.array }
      <Button mode=#contained onPress={_ => dispatch(Navigate(Election_New))}>
        { "New election" -> React.string }
      </Button>
    </>
  | Home_Identities =>
    <>
      <X.Title>{ "Identités" -> React.string }</X.Title>
      <List.Section title="" style=X.styles["margin-x"]>
      { Array.map(state.ids, (id) => {
        <List.Item
          key=id.hexPublicKey
          title=("0x" ++ id.hexPublicKey)
        />
      }) -> React.array }
      </List.Section>
      <Button mode=#outlined onPress=genIdentity>
        { "Generate identity" -> React.string }
      </Button>
      <Button mode=#outlined onPress={_ => Identity.clear()}>
        { "Clear identities" -> React.string }
      </Button>
    </>
  | Home_Transactions =>
    <Home_Transactions />
  | _ =>
    <Text>{"Unknown route"->React.string}</Text>
  }
}
