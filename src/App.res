@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(StateReducer.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(StateMsg.Reset)
    None
  })

  if ReactNative.Platform.os == #web {
    let url = RescriptReactRouter.useUrl()
    if url.path != state.route {
      dispatch(Navigate(url.path))
    }
  }

  <Layout state dispatch>

    { switch state.route {

    | list{"elections"}         => <ElectionIndex />
    | list{"elections", "new"}  => <ElectionNew />
    | list{"elections", id}     => <ElectionShow electionId=id />

    | list{"ballots", id}       => <BallotShow ballotId=id />

    | list{"identities"}       => <Identity_Index />
    | list{"identities", id}   => <Identity_Show publicKey=id />

    | list{"trustees"}         => <Trustee_Index />
    | list{"events"}           => <Event_Index />
    | list{"contacts"}         => <ContactIndex />

    | list{"settings"}         => <Settings_View />

    | list{} | list{""}        => <Home_View />

    | route                    =>
      Js.log("Unknown route")
      Js.log(route)
      <Home_View />
    } }

    //<Navigation />

  </Layout>
}
