import { Link } from "react-router-dom"

export default function() {
	return (
		<div>
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
