open Mui

let rs = (string) => React.string(string)

@react.component
let make = (~state: State.state, ~dispatch, ~id) => {

	<div>
    <h2>{rs(state.election.name)}</h2>
		<CandidateSelect state dispatch />
	</div>
}
