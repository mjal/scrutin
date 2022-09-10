@react.component
let make = (~name, ~dispatch) => {

  let onClick = _ => {
    dispatch(State.RemoveVoter(name))
  }

	<p key={name}>
		{React.string(name)}
		<a onClick>
      {React.string("(remove)")}
		</a>
	</p>
}

