module View = {
  type t =
    | Home
    | FetchingElection(int)
    | Election(int)
}

module User = {
  type t = { token: string }
}

type state = {
  view: View.t,
  user: User.t,
  election: Election.t,
  loading: bool
}

let initialState = {
  view: Home,
  user: { token: "" },
  election: Election.initial,
  loading: false
}

let reducer = (state, action: Action.t) => {
  switch (action) {
    | SetLoading(loading) => { ...state, loading }
    | PostElection =>
      state.election
      -> Election.post
      -> Promise.then(res => {
        res
        -> Webapi.Fetch.Response.json
        -> Promise.thenResolve(Election.from_json)
        -> Promise.thenResolve(election => {
          let id = election.id
          Js.log(j`/election/$id`)
          // RescriptReactRouter.push(j`/election/$id`)
        })
      })
      -> ignore
      state
    | _ => {
      ...state,
      election: Election.reducer(state.election, action)
    }
  }
}
