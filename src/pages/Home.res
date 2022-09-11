@react.component
let make = (~state: State.state, ~dispatch: State.action => unit) => {

  let updateElectionName = (event) =>
    dispatch(SetElectionName(ReactEvent.Form.currentTarget(event)["value"]))

  let onClick = _ => {
    //%raw(`
    //  fetch('http://0.0.0.0:8000/elections/', {
    //      method: 'POST',
    //      headers: { 'Content-Type': 'application/json' },
    //      body: JSON.stringify(state.election)
    //  })
    //  .then(response => response.json())
    //  .then(data => next(data))
    //`)

    RescriptReactRouter.push("/election/1")
  }

  open Mui
  let { rs, texts } = module(Helper)

	<div>
		<TextField
      label=rs("Nom de l'élection")
      variant=#outlined
			value=texts(state.election.name)
      onChange=updateElectionName
		/>
		<CandidateList state dispatch />
		<VoterList state dispatch />
    <br />
		<Button variant=#contained onClick>{rs("Create Election")}</Button>
	</div>
}
