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

    | Home_Elections    => <Election_Home />
    | Home_Identities   => <Identity_Home />
    | Home_Trustees     => <Trustee_Home />
    | Home_Transactions => <Transaction_Home />

    | Election_New => <Election_New />
    | Election_Show(eventHash) => <Election_Show eventHash />

    | Ballot_Show(eventHash) => <Ballot_Show eventHash />

    | Identity_Show(publicKey) => <Identity_Show publicKey />

    } }

    <Navigation />

  </Layout>
}
