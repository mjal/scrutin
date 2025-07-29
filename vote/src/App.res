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
    | list{"elections", "new"} => <Election_New />

    | list{"elections", uuid, ...electionRoute} =>
      switch Map.String.get(state.electionDatas, uuid) {
      | None =>
        switch Map.String.get(state.electionsTryFetch, uuid) {
        | Some(true) => ()
        | _ => dispatch(StateMsg.Election_Fetch(uuid))
        }
        <S.P
          text="Nous recherchons l'élection..."
          style={Style.textStyle(~marginTop=50.0->Style.dp, ())}
        />
      | Some(electionData) =>
        switch electionRoute {
        | list{} => <ElectionShow electionData />
        | list{"booth"} => <Election_Booth electionData />
        | list{"tally"} => <ElectionTally electionData />
        | list{"share"} => <ElectionShare electionData />
        | list{"result"} =>
          switch electionData.setup.election.votingMethod {
          | Some(#majorityJudgement) => <ElectionResult_MajorityJudgement electionData />
          | _ => <ElectionResult electionData />
          }
        | route =>
          Js.log(("Unknown election route", route))
          <HomeView />
        }
      }

    | list{} | list{""} => <HomeView />

    | route =>
      Js.log(("Unknown route", route))
      <HomeView />
    }}
    <View style={Style.viewStyle(~margin=60.0->Style.dp, ())} />
  </Layout>
}
