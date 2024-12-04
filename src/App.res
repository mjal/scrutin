@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(StateReducer.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(StateMsg.Reset)
    Js.log(Sirona.Trustee.create())
    let (_priv, trustee) = Sirona.Trustee.create()
    Js.log(trustee)
    let question : Sirona.QuestionH.t =  {
      answers: ["Answer1", "Answer2"],
      min: 1,
      max: 1,
      question: "Question"
    }
    let election = Sirona.Election.create("Name", "Desc", [Sirona.Trustee.fromJSON(trustee)], [question])
    Js.log(election)
    None
  })

  //React.useEffect0(() => {
  //  Js.Global.setInterval(() => {
  //    dispatch(StateMsg.FetchLatest)
  //  }, 5000)->ignore
  //  None
  //})

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
    | list{"elections", "new", "step2"} => <ElectionNewStep2 />
    | list{"elections", "new", "step3"} => <ElectionNewStep3 />
    | list{"elections", "new", "step4"} => <ElectionNewStep4 />
    | list{"elections", "new", "step5"} => <ElectionNewStep5 />

    // TODO: Rename electionId -> uuid
    | list{"elections", electionId, ...electionRoute} =>
      switch Map.String.get(state.elections, electionId) {
      | None =>
        switch Map.String.get(state.electionsTryFetch, electionId) {
          | Some(true) => ()
          | _ => dispatch(StateMsg.ElectionFetch(electionId))
        }
        <NotFoundYet />
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
          <ElectionInvitePhone election />
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
