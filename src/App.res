@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(Action.Init)
    None
  })

  Js.log(state.route)

  <Layout state dispatch>

    <Header />

    { switch state.route {
    | Home_Elections
    | Home_Identities
    | Home_Transactions
    => <Home />
    | Election_New => <Election_New />
    | Election_Show(eventHash) => <Election_Show eventHash />
    | Identity_Show(publicKey) => <Identity_Show publicKey />
    } }

    <Navigation />
  </Layout>
}
