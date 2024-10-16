@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(StateReducer.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(StateMsg.Reset)
    None
  })

  React.useEffect0(() => {
    Js.Global.setInterval(() => {
      dispatch(StateMsg.FetchLatest)
    }, 5000)->ignore
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

    | list{"elections", electionId, ...electionRoute} =>

      switch Map.String.get(state.elections, electionId) {
      | None => <NotFoundYet />
      | Some(election) =>
        switch electionRoute {
        | list{} =>
          <ElectionShow election electionId />
        | list{"challenge", userToken} => // Unused
          <ElectionChallenge election electionId userToken />
        | list{"token", secret} => // Unused
          <ElectionToken election electionId secret />
        | list{"invite"} =>
          <ElectionInvite election electionId />
        | list{"invite_link"} =>
          <ElectionInviteLink election electionId />
        | list{"invite_email"} =>
          <ElectionInviteEmail election electionId />
        | list{"invite_phone"} =>
          <ElectionInvitePhone election electionId />
        | list{"invite_manage"} =>
          <ElectionInviteManage election />
        | list{"result"} =>
          <ElectionResult election electionId />
        | list{"booth"} =>
          <ElectionBooth election electionId />
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
