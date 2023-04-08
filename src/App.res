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

    | Election_Index    => <Election_Index />
    | Identity_Index    => <Identity_Index />
    | Trustee_Index     => <Trustee_Index />
    | Event_Index       => <Event_Index />
    | Contact_Index     => <Contact_Index />

    | Election_New => <Election_New />
    | Election_Show(electionId) => <Election_Show electionId />

    | Ballot_Show(ballotId) => <Ballot_Show ballotId />

    | Identity_Show(publicKey) => <Identity_Show publicKey />

    | Settings => <Settings_View />
    } }

    //<Navigation />

  </Layout>
}
