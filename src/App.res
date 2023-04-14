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

    | list{"identities"}       => <IdentityIndex />
    | list{"identities", id}   => <IdentityShow publicKey=id />

    | list{"trustees"}         => <TrusteeIndex />
    | list{"events"}           => <EventIndex />
    | list{"contacts"}         => <ContactIndex />

    | list{"settings"}         => <SettingsView />

    | list{} | list{""}        => <HomeView />

    | route                    =>
      Js.log("Unknown route")
      Js.log(route)
      <HomeView />
    } }

    //<Navigation />

  </Layout>
}
