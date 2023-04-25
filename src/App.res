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
  StateRedirectOriginal.use()

  <Layout state dispatch>
    {switch state.route {
    | list{"elections", "search"} => <ElectionSearch />
    | list{"elections", "new"} => <ElectionNew />

    | list{"elections", electionId} =>
      switch State.getElection(state, electionId) {
      | None => <NotFoundYet />
      | Some(election) => <ElectionShow election electionId />
      }

    | list{"elections", electionId, "invite"} =>
      switch State.getElection(state, electionId) {
      | None => <NotFoundYet />
      | Some(election) => <ElectionInvite election electionId />
      }

    | list{"elections", electionId, "invite_link"} =>
      switch State.getElection(state, electionId) {
      | None => <NotFoundYet />
      | Some(election) => <ElectionInviteLink election electionId />
      }

    | list{"elections", electionId, "invite_email"} =>
      switch State.getElection(state, electionId) {
      | None => <NotFoundYet />
      | Some(election) => <ElectionInviteEmail election electionId />
      }

    | list{"elections", electionId, "invite_manage"} =>
      switch State.getElection(state, electionId) {
      | None => <NotFoundYet />
      | Some(election) => <ElectionInviteManage election />
      }

    | list{"elections", electionId, "result"} =>
      switch State.getElection(state, electionId) {
      | None => <NotFoundYet />
      | Some(election) => <ElectionResult election electionId />
      }

    | list{"elections", electionId, "booth"} =>
      switch State.getElection(state, electionId) {
      | None => <NotFoundYet />
      | Some(election) => <ElectionBooth election electionId />
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
