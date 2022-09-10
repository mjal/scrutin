open Mui

@react.component
let make = (~state: State.state, ~dispatch: State.action => unit) => {
	let (email, setEmail) = React.useState(_ => "")

  let rs = React.string

  let onChange = (event) =>
    setEmail(ReactEvent.Form.currentTarget(event)["value"])

	let addVoter = _ => {
		dispatch(AddVoter(email))
		setEmail(_ => "")
	}

	let onClick = _ => addVoter()

	let onKeyDown = event => {
		if ReactEvent.Keyboard.key(event) == "Enter" {
      addVoter()
		}
	}

	<div>
		<h2>{"Votants"->rs}</h2>
    <Mui.List>
      {
        Js.Array2.map(state.voters, email =>
          <Voter key={email} name={email} dispatch={dispatch} />
        )->React.array
      }
    </Mui.List>
		<Mui.TextField label=React.string("Email") variant=#outlined value={TextField.Value.string(email)} onChange />
		<Mui.Button variant=#contained size=#large onClick={addVoter} onKeyDown>{React.string("Ajouter")}</Mui.Button>
	</div>
}
