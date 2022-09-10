open Mui

let s = (string) => Mui.Box.Value.string(string)

module Fetch = {
  type response

  @send external json: response => Js.Promise.t<'a> = "json"
  @val external fetch: string => Js.Promise.t<response> = "fetch"
}

@react.component
let make = (~state: State.state, ~dispatch: State.action => unit) => {

  let updateElectionName = (event) =>
    dispatch(SetElectionName(ReactEvent.Form.currentTarget(event)["value"]))

  let onClick = _ => {
    RescriptReactRouter.push("/election/1")
  }

	<div>
		<TextField
      id="outlined-basic"
      label=React.string("Nom de l'élection")
      variant=#outlined
			value=Mui.TextField.Value.string(state.electionName)
      onChange=updateElectionName
		/>
		<CandidateList state={state} dispatch={dispatch} />
		<VoterList state={state} dispatch={dispatch} />
    <br />
		<Button variant=#contained onClick>{React.string("Create Election")}</Button>
	</div>
}
