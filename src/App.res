@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(Action.Init)
    None
  })

  <Layout state dispatch>

    <Header />

    { switch state.route {

    | Home_Elections    => <Home_Elections />
    | Home_Identities   => <Home_Identities />
    | Home_Trustees     => <Home_Trustees />
    | Home_Transactions => <Home_Transactions />

    | Election_New => <Election_New />
    | Election_Show(eventHash) => <Election_Show eventHash />

    | Ballot_Show(eventHash) => <Ballot_Show eventHash />

    | Identity_Show(publicKey) => <Identity_Show publicKey />

    } }

    <Navigation />

  </Layout>
}
