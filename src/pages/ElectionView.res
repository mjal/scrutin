open ReactNative; open Helper

@react.component
let make = (~state: State.state, ~dispatch, ~id) => {
	<View>
    <Text>{rs(state.election.name)}</Text>
		<CandidateSelect state dispatch />
	</View>
}
