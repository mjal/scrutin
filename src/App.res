let default = () => {
  let (state, dispatch) = React.useReducer(State.reducer, State.initialState)

  let url = RescriptReactRouter.useUrl()

	<Mui.Container fixed=true>
    <Header />
    {
      switch url.path {
        | list{"election", id} =>
          <Election state dispatch id />
        | list{} =>
	    	  <Home state dispatch />
        | _ =>
          // TODO <NotFound />
	    	  <Home state dispatch />
      }
    }
  </Mui.Container>
}
