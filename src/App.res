@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(State.reducer, State.initialState)

	<Mui.Container fixed=true>
		<Mui.Box
		  display=Mui.Box.Value.string("flex")
		  justifyContent=Mui.Box.Value.string("center")
		  alignItems=Mui.Box.Value.string("center")
		  minHeight=Mui.Box.Value.string("30vh")
		>
			<h1>
        {"Scrutin:"->React.string}
        <br />
        {"end-to-end encrypted"->React.string}
        <br />
        {"verifiable election app"->React.string}
			</h1>
		</Mui.Box>
		<Home state={state} dispatch={dispatch} />
  </Mui.Container>
}
