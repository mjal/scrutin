@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(State.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(StateMsg.Reset)
    None
  })

  <Layout state dispatch>

    <Header />

    { switch state.route {

    | Home_Elections    => <Election_Home />
    | Home_Identities   => <Identity_Home />
    | Home_Trustees     => <Trustee_Home />
    | Home_Transactions => <Transaction_Home />
    | Contact_Index     => <Contact_Index />

    | Election_New => <ElectionNew />
    | Election_Show(contentHash) => <ElectionShow contentHash />

    | Ballot_Show(contentHash) => <Ballot_Show contentHash />

    | Identity_Show(publicKey) => <Identity_Show publicKey />

    | Settings => <Settings_View />
    } }

    //<Navigation />

  </Layout>
}
