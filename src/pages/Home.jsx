import { Link } from "react-router-dom"

export default function({state, dispatch}) {
	return (
		<div>
			{state.voters.map(voter =>
				<h4>Voter {voter}</h4>
			)}
			<h2>Setup election:</h2>
			<p>
				<Link to="/candidates">Add candidates</Link>
			</p>
			<p>
				<Link to="/voters">Add voters</Link>
			</p>
			<p>Start election</p>

			<h2>Vote:</h2>
			<p>
				1. Login
				2. Vote (Select + send)
			</p>
		</div>
	)
}
