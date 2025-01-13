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
    {switch state.route {
    | list{"elections", "new"} =>
      <Election_New />

    | list{"elections", uuid, ...electionRoute} =>
      switch Map.String.get(state.electionDatas, uuid) {
      | None =>
        switch Map.String.get(state.electionsTryFetch, uuid) {
        | Some(true) => ()
        | _ => dispatch(StateMsg.ElectionFetch(uuid))
        }
        <NotFoundYet />
      | Some(electionData) =>
        switch electionRoute {
        | list{} =>
          <ElectionShow electionData />
        | list{"share"} =>
          <ElectionShare electionData />
        //| list{"challenge", userToken} => // Unused
        //  <ElectionChallenge electionData userToken />
        //| list{"token", secret} => // Unused
        //  <ElectionToken electionData secret />
        //| list{"invite"} =>
        //  <ElectionInvite electionData />
        //| list{"invite_link"} =>
        //  <ElectionInviteLink electionData />
        //| list{"invite_email"} =>
        //  <ElectionInviteEmail electionData />
        //| list{"invite_phone"} =>
        //  <ElectionInvitePhone electionData />
        //| list{"invite_manage"} =>
        //  <ElectionInviteManage electionData />
        | list{"result"} =>
          <ElectionResult electionData />
        | list{"booth"} =>
          <Election_Booth electionData />
        //| list{"avote"} =>
        //  <ElectionAVote electionData />
        | list{"tally"} =>
          <ElectionTally electionData />
        | route =>
          Js.log(("Unknown election route", route))
          <HomeView />
        }
      }

    //| list{"identities"} => <IdentityIndex />
    //| list{"identities", id} => <IdentityShow publicKey=id />

    //| list{"trustees"} => <TrusteeIndex />
    //| list{"events"} => <EventIndex />
    //| list{"contacts"} => <ContactIndex />

    //| list{"settings"} => <SettingsView />

    | list{} | list{""} => <HomeView />

    | route =>
      Js.log(("Unknown route", route))
      <HomeView />
    }}
    <View style=Style.viewStyle(~margin=60.0->Style.dp, ()) />
  </Layout>
}
