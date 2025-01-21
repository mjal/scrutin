let reducer = (state: State.t, action: StateMsg.t) => {
  switch action {
  | Reset => (State.initial, [ StateEffect.goToUrl, ])

  | Election_Fetch(uuid) =>
    let electionsTryFetch = Map.String.set(state.electionsTryFetch, uuid, true)
    ({...state, electionsTryFetch}, [StateEffect.fetchElection(uuid)])

  | Election_Set(uuid, electionData) =>
    let electionDatas = Map.String.set(state.electionDatas, uuid, electionData)
    ({...state, electionDatas}, [])

  | Config_Store_Language(language) => (state, [StateEffect.storeLanguage(language)])

  | Navigate(route) =>
    if ReactNative.Platform.os == #web {
      if route != RescriptReactRouter.dangerouslyGetInitialUrl().path {
        let path = Belt.List.reduce(route, "", (a, b) => a ++ "/" ++ b)
        let path = if path == "" {
          "/"
        } else {
          path
        }
        RescriptReactRouter.push(path)
      }
    }
    ({...state, route}, [])
  }
}
