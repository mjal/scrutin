import { useState } from "react"
import { Link } from "react-router-dom"

export default function({state, dispatch}) {
	const [voterName, setVoterName] = useState("")

	const voterEl = (voter) => {
		return (
			<p key={voter}>
				{voter} - 
				<a onClick={() => dispatch({type: "removeVoter", value: voter})}>
					(remove)
				</a>
			</p>
		)
	}

	const addVoter = () => {
		dispatch({type: "addVoter", value: voterName})
		setVoterName("")
	}

	const onKeypress = (event) => {
		if (event.key == "Enter") {
			addVoter()
		}
	}

	return (
		<div>
			VoterList
			<br />
			{state.voters.map(voterEl)}
			<br />
			Add a new voter:
			<br />
			<input onChange={(e) => setVoterName(e.target.value)} />
			<a onClick={addVoter}>(add)</a>
			<br />
			<Link to="/">Back</Link>
		</div>
	)
}

