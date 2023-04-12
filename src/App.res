@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(StateReducer.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(StateMsg.Reset)
    None
  })

  <Layout state dispatch>

    <Header />

    { switch state.route {

    | list{"elections"}         => <Election_Index />
    | list{"elections", "new"}  => <Election_New />
    | list{"elections", id}     => <Election_Show electionId=id />

    | list{"ballots", id}       => <Ballot_Show ballotId=id />

    | list{"identities"}       => <Identity_Index />
    | list{"identities", id}   => <Identity_Show publicKey=id />

    | list{"trustees"}         => <Trustee_Index />
    | list{"events"}           => <Event_Index />
    | list{"contacts"}         => <Contact_Index />

    | list{"settings"}         => <Settings_View />

    | _                        => <Election_Index />
    } }

    //<Navigation />

  </Layout>
}
