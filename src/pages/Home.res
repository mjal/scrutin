let s = (string) => Mui.Box.Value.string(string)

@react.component
let make = (~state: State.state, ~dispatch: State.action => unit) => {

  let updateElectionName = (event) =>
    dispatch(SetElectionName(ReactEvent.Form.currentTarget(event)["value"]))

	<div>
		<Mui.TextField
      id="outlined-basic"
      label=React.string("Nom de l'élection")
      variant=#outlined
			value=Mui.TextField.Value.string(state.electionName)
      onChange=updateElectionName
		/>
    {/*
		<CandidateList state={state} dispatch={dispatch} />
		<VoterList state={state} dispatch={dispatch} />
    */React.string("")}
    <br />
		<Mui.Button variant=#contained>{React.string("Create Election")}</Mui.Button>
	</div>
}
