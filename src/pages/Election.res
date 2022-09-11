@react.component
let make = (~state: State.state, ~dispatch, ~id) => {
  open Helper

	<div>
    <h2>{rs(state.election.name)}</h2>
		<CandidateSelect state dispatch />
	</div>
}
