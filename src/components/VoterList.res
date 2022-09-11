open Mui; open Helper

@react.component
let make = (~state: State.state, ~dispatch: State.action => unit) => {
	let (email, setEmail) = React.useState(_ => "")

	let addVoter = _ => {
		dispatch(AddVoter(email))
		setEmail(_ => "")
	}

  let onChange = (event) =>
    setEmail(ReactEvent.Form.currentTarget(event)["value"])

	let onClick = _ => addVoter()

	let onKeyDown = event => {
		if ReactEvent.Keyboard.key(event) == "Enter" {
      addVoter()
		}
	}

	<div>
		<h2>{"Votants"->rs}</h2>
    <List>
      {
        state.election.voters
        -> Js.Array2.map(voter => <Voter key={voter.name} name={voter.name} dispatch={dispatch} />)
        -> React.array
      }
    </List>
		<TextField label=rs("Email") variant=#outlined value={texts(email)} onChange />
		<Button variant=#contained size=#large onClick onKeyDown>{rs("Ajouter")}</Button>
	</div>
}
