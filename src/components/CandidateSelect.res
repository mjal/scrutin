open Mui; open Helper

@react.component
let make = (~dispatch, ~state: State.state) => {
  let onClick = _ => ()

	<div>
		<h2>{rs("Selectionnez votre candidat")}</h2>
    <RadioGroup>
      {
        state.election.candidates
        -> Js.Array2.map(candidate =>
          <FormControlLabel value={Any.make(candidate.name)} control={<Radio />} label={rs(candidate.name)} />
        )
        -> React.array
      }
    </RadioGroup>
		<Button variant=#contained size=#large onClick>{rs("Voter")}</Button>
	</div>
}

