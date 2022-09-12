open Mui; open Helper

let default = () => {
  let (state, dispatch) = React.useReducer(State.reducer, State.initialState)

  let url = RescriptReactRouter.useUrl()

	<Mui.Container fixed=true>
    <Header />
    {
      switch url.path {
        | list{"election", id_str} =>
          let id = switch Belt.Int.fromString(id_str) {
            | Some(id) => id
            | None => 0
          }
          if !state.loading && state.election.id != id {
            dispatch(SetLoading(true))
            Webapi.Fetch.fetch(j`http://localhost:8000/elections/$id`)
            ->Promise.then(Webapi.Fetch.Response.json)
            ->Promise.thenResolve(o => {
              dispatch(LoadElectionJson(o))
              dispatch(SetLoading(false))
            })
            ->ignore
          }

          if state.loading {
            <h1>{"Loading"->rs}</h1>
          } else {
            <ElectionView state dispatch id />
          }
        | list{} =>
	    	  <HomeView state dispatch />
        | _ =>
          // TODO <NotFound />
	    	  <HomeView state dispatch />
      }
    }
  </Mui.Container>
}
