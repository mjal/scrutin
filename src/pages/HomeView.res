open Mui; open Helper

@scope("window") @val
external alert: string => unit = "alert2"

@react.component
let make = (~state: State.state, ~dispatch: Action.t => unit) => {

  let updateElectionName = (event) =>
    dispatch(SetElectionName(ReactEvent.Form.currentTarget(event)["value"]))

  let onClick = _ => {
    let a = Webapi.Fetch.fetchWithInit(
      "http://localhost:8000/elections/",
      Webapi.Fetch.RequestInit.make(
        ~method_=Post,
        ~body=Webapi.Fetch.BodyInit.make(Js.Json.stringify(Election.to_json(state.election))),
        ~headers=Webapi.Fetch.HeadersInit.make({"Content-Type": "application/json"}),
        (),
      ),
    )
    ->Promise.then(Webapi.Fetch.Response.json)
    ->Promise.thenResolve(Election.from_json)
    ->Promise.thenResolve(election => {
      let id = election.id
      RescriptReactRouter.push(j`/election/$id`)
    })
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
