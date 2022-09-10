@react.component
let make = (~state: State.state, ~dispatch: State.action => unit) => {
	let (voterName, setVoterName) = React.useState(_ => "")

  // TODO: Move to his own component
	let voterEl = (voter) => {

    let onClick = _ =>
      dispatch(RemoveVoter(voter))

		<p key={voter}>
			{React.string(voter)}
			<a onClick={onClick}>
        {React.string("(remove)")}
			</a>
		</p>
  }

	let addVoter = _ => {
		dispatch(AddVoter(voterName))
		setVoterName(_ => "")
	}

	let onKeyDown = event => {
		if ReactEvent.Keyboard.key(event) == "Enter" {
      addVoter()
		}
	}

  let updateVoterName = (event) =>
    setVoterName(ReactEvent.Form.currentTarget(event)["value"])

	<div>
		<h1>{React.string("VoterList")}</h1>
		<br />
		{Js.Array2.map(state.voters, voterEl) -> React.array}
		<br />
    {React.string("Add a new voter:")}
		<br />
		<input onChange={updateVoterName} onKeyDown />
		<a onClick={addVoter}>{"(add)"->React.string}</a>
		<br />
	</div>
}
