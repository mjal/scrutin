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

  <Layout state dispatch>
    {switch state.route {
    | list{"elections", "search"} => <ElectionSearch />
    | list{"elections", "new"} => <ElectionNew />

    // TODO: Rename electionId -> uuid
    | list{"elections", electionId, ...electionRoute} =>
      switch Map.String.get(state.electionDatas, electionId) {
      | None =>
        switch Map.String.get(state.electionsTryFetch, electionId) {
          | Some(true) => () // FIX: After some time, (~20s ?) Try fetch again. Use timestamps (as float) instead of bool
          | _ => dispatch(StateMsg.ElectionFetch(electionId)) // TODO: Rename
        }
        <NotFoundYet />
      | Some(electionData) =>
        switch electionRoute {
        | list{} =>
          <ElectionShow electionData electionId />
        | list{"challenge", userToken} => // Unused
          <ElectionChallenge electionData electionId userToken />
        | list{"token", secret} => // Unused
          <ElectionToken electionData electionId secret />
        | list{"invite"} =>
          <ElectionInvite electionData electionId />
        | list{"invite_link"} =>
          <ElectionInviteLink electionData electionId />
        | list{"invite_email"} =>
          <ElectionInviteEmail electionData electionId />
        | list{"invite_phone"} =>
          <ElectionInvitePhone electionData />
        | list{"invite_manage"} =>
          <ElectionInviteManage electionData />
        | list{"result"} =>
          <ElectionResult electionData electionId />
        | list{"openbooth"} =>
          <Election_OpenBooth electionData />
        | list{"avote"} =>
          <ElectionAVote electionData electionId />
        | list{"tally"} =>
          <ElectionTally electionData electionId />
        | route =>
          Js.log(("Unknown election route", route))
          <HomeView />
        }
      }

    | list{"identities"} => <IdentityIndex />
    | list{"identities", id} => <IdentityShow publicKey=id />

    | list{"trustees"} => <TrusteeIndex />
    | list{"events"} => <EventIndex />
    | list{"contacts"} => <ContactIndex />

    | list{"settings"} => <SettingsView />

    | list{} | list{""} => <HomeView />

    | route =>
      Js.log(("Unknown route", route))
      <HomeView />
    }}
  </Layout>
}
