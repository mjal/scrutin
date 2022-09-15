open ReactNative; open Helper

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(State.reducer, State.initialState)

	<View>
    <Header />
    {
    /*
    {
      switch url.path {
        | list{"election", id_str} =>
          let id = switch Belt.Int.fromString(id_str) {
            | Some(id) => id
            | None => 0
          }
          if !state.loading && state.election.id != id {
            dispatch(SetLoading(true))
            Election.get(id)
            -> Promise.thenResolve(o => {
              dispatch(LoadElectionJson(o))
              dispatch(SetLoading(false))
            })
            -> ignore
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
    */
    <Text>{rs("")}</Text>
    }
  </View>
}
