@react.component
let make = () => {
  let (state, dispatch) = Context.use()

  let genIdentity = _ => {
    dispatch(Identity_Add(Identity.make()))
  }

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

    <X.Title>{ "Elections" -> React.string }</X.Title>
    <Button mode=#contained onPress={_ => dispatch(Navigate(Election_New))}>
      { "New election" -> React.string }
    </Button>

    <X.Title>{ "Ballots"   -> React.string }</X.Title>

    <X.Title>{ "Trustees"  -> React.string }</X.Title>

    <X.Title>{ "Transactions" -> React.string }</X.Title>
    <List.Section title="" style=X.styles["margin-x"]>
    { Array.map(state.txs, (tx) => {
      <List.Item
        key=tx.eventHash
        title=("0x" ++ tx.eventHash)
      />
    }) -> React.array }
    </List.Section>
  </>

  /*
  React.useEffect0(_ => {
    if Option.isNone(state.user) {
      dispatch(Action.Navigate(Route.User_Register))
    }
    None
  })

  Js.log(state.user)

  switch state.user {
  | None =>
    "Redirecting..." -> React.string
  | Some(_user) =>
    <>
      <Button mode=#contained onPress={_ => dispatch(Navigate(Route.ElectionNew))} style=X.styles["margin-x"]>
        {"Creer une nouvelle election" -> React.string}
      </Button>
      <ElectionList title="Elections en cours" elections=state.elections loading=state.elections_loading />
    </>
  }
  */
}
