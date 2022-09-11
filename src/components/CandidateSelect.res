open Mui

let rs = React.string

@react.component
let make = (~dispatch: State.action => (), ~state: State.state) => {

  let onClick = _ =>
    ()

	<div>
		<h2>{"Selectionnez votre candidat"->React.string}</h2>
    <RadioGroup>
      {Js.Array2.map(state.election.candidates, candidate =>
        <FormControlLabel value={Any.make(candidate.name)} control={<Radio />} label={candidate.name->rs} />
      )->React.array}
    </RadioGroup>
		<Button variant=#contained size=#large onClick>{"Voter"->rs}</Button>
	</div>
}

