open Mui; open Helper

@scope("window") @val
external alert: string => unit = "alert2"

@react.component
let make = (~state: State.state, ~dispatch: Action.t => unit) => {

  let updateElectionName = (event) =>
    dispatch(SetElectionName(ReactEvent.Form.currentTarget(event)["value"]))

  let onClick = _ => {
    state.election
    -> Election.post
    -> Promise.then(res => {
      res
      -> Webapi.Fetch.Response.json
      -> Promise.thenResolve(Election.from_json)
      -> Promise.thenResolve(election => {
        let id = election.id
        RescriptReactRouter.push(j`/election/$id`)
      })
    })
    -> ignore
  }

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
