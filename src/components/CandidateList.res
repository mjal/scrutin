open Mui; open Helper

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

  let onSubmit = e => {
    dispatch(State.AddCandidate(lastName ++ " " ++ firstName))
    setFirstName(_ => "")
    setLastName(_ => "")
    ReactEvent.Synthetic.preventDefault(e)
  }

	<div>
		<h2>{"Candidats"->rs}</h2>
    <List>
      {
        state.election.candidates
        -> Js.Array2.map(candidate =>
          <Candidate key={candidate.name} name={candidate.name} dispatch={dispatch} />
        )
        -> React.array
      }
		</List>
    <form onSubmit>
		  <TextField label=rs("Prénom") variant=#outlined value={texts(firstName)} onChange={onChangeFirstName} />
		  <TextField label=rs("Nom") variant=#outlined value={texts(lastName)} onChange={onChangeLastName} />
		  <Button \"type"=Mui.Button.Type.string("submit") variant=#contained size=#large>{rs("Ajouter")}</Button>
    </form>
	</div>
}
