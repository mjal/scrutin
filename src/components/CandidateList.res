@react.component
let make = (~dispatch: State.action => (), ~state: State.state) => {
	let (firstName, setFirstName) = React.useState(_ => "")
	let (lastName, setLastName) = React.useState(_ => "")

  let onChangeFirstName = event => {
    setFirstName(ReactEvent.Form.currentTarget(event)["value"])
  }

  let onChangeLastName = event => {
    setLastName(ReactEvent.Form.currentTarget(event)["value"])
  }

  // TODO: Form and onSubmit ?
  let onClick = e => {
    dispatch(State.AddCandidate(lastName ++ " " ++ firstName))
    setFirstName(_=>"")
    setLastName(_=>"")
  }

	<div>
		<h2>{"Candidats"->React.string}</h2>
    <Mui.List>
    {Js.Array2.map(state.candidates, name =>
      <Candidate key={name} name={name} dispatch={dispatch} />
    )->React.array}
		</Mui.List>
		<Mui.TextField label=React.string("Prénom") variant=#outlined value={Mui.TextField.Value.string(firstName)} onChange={onChangeFirstName} />
		<Mui.TextField label=React.string("Nom") variant=#outlined value={Mui.TextField.Value.string(lastName)} onChange={onChangeLastName} />
		<Mui.Button variant=#contained size=#large onClick>{React.string("Ajouter")}</Mui.Button>
	</div>
}
