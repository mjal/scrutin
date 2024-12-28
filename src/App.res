@react.component
let make = () => {
  let (state, dispatch) = UseTea.useTea(StateReducer.reducer, State.initial)

  React.useEffect0(() => {
    dispatch(StateMsg.Reset)
    let (_priv, trustee) = Trustee.generate()
    let question : QuestionH.t =  {
      answers: ["Answer1", "Answer2"],
      blank: false,
      min: 1,
      max: 1,
      question: "Question"
    }
    let election = Election.create("Name", "Desc", [Trustee.fromJSON(trustee)], [question])
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
      switch Map.String.get(state.setups, electionId) {
      | None =>
        switch Map.String.get(state.electionsTryFetch, electionId) {
          | Some(true) => ()
          | _ => dispatch(StateMsg.ElectionFetch(electionId)) // TODO: Rename
        }
        <NotFoundYet />
      | Some(setup) =>
        switch electionRoute {
        | list{} =>
          <ElectionShow setup electionId />
        | list{"challenge", userToken} => // Unused
          <ElectionChallenge setup electionId userToken />
        | list{"token", secret} => // Unused
          <ElectionToken setup electionId secret />
        | list{"invite"} =>
          <ElectionInvite setup electionId />
        | list{"invite_link"} =>
          <ElectionInviteLink setup electionId />
        | list{"invite_email"} =>
          <ElectionInviteEmail setup electionId />
        | list{"invite_phone"} =>
          <ElectionInvitePhone setup />
        | list{"invite_manage"} =>
          <ElectionInviteManage setup />
        | list{"result"} =>
          <ElectionResult setup electionId />
        | list{"booth"} =>
          <ElectionBooth setup electionId />
        | list{"avote"} =>
          <ElectionAVote setup electionId />
        | list{"tally"} =>
          <ElectionTally setup electionId />
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
