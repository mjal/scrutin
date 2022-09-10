open Mui

let rs = (string) => React.string(string)

@react.component
let make = (~state: State.state, ~dispatch, ~id) => {

	<div>
    <h2>{rs(state.electionName)}</h2>
		<CandidateSelect state dispatch />
	</div>
}
