@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(StateReducer.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(StateMsg.Reset)
    None
  })

  // Go to url
  if ReactNative.Platform.os == #web {
    let url = RescriptReactRouter.useUrl()
    if url.path != state.route {
      dispatch(Navigate(url.path))
    }
  }

  // Use latest version of objects
  StateUseLatest.useLatest()

  <Layout state dispatch>

    { switch state.route {

    | list{"elections"}         => <ElectionIndex />
    | list{"elections", "new"}  => <ElectionNew />

    | list{"elections", electionId} =>
      switch State.getElection(state, electionId) {
      | None => <NotFoundYet />
      | Some(election) => <ElectionShow election electionId />
      }

    | list{"elections", electionId, "result"} =>
      switch State.getElection(state, electionId) {
      | None => <NotFoundYet />
      | Some(election) => <ElectionResult election electionId />
      }

    | list{"ballots", ballotId} =>
      switch State.getBallot(state, ballotId) {
      | None => <NotFoundYet />
      | Some(ballot) => <BallotShow ballot ballotId />
      }

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
