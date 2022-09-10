import { Link } from "react-router-dom"
import { Button, TextField } from '@mui/material';
import CandidateList from '../components/CandidateList';
import VoterList from '../components/VoterList';

export default function({state, dispatch}) {
	return (
		<div>
			<TextField id="outlined-basic" label="Nom de l'élection" variant="outlined"
				value={state.electionName} onChange={(e) => dispatch({type: "electionName", value: e.target.value})}
			/>

			<CandidateList state={state} dispatch={dispatch} />

			<h2>Voters</h2>
			<VoterList state={state} dispatch={dispatch} />

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
			<Button variant="contained">Hello World</Button>
		</div>
	)
}
