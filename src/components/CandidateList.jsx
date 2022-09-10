import { useState } from "react"
import { Link } from "react-router-dom"
import { Grid, TextField, Box, Button } from "@mui/material"
import Candidate from "./Candidate"

export default function({ dispatch, state }) {
	const [firstName, setFirstName] = useState("")
	const [lastName, setLastName] = useState("")
	return (
		<div>
			<h2>Candidats</h2>
			<Grid container spacing={1}>
				{state.candidates.map(name => <Candidate name={name} key={name} />)}
			</Grid>
			<Box
    	  component="form"
    	  sx={{ '& > :not(style)': { m: 1, width: '25ch' }, }}
    	  noValidate
    	  autoComplete="off"
    	>
				<TextField id="outlined-basic" label="Nom" variant="outlined"
					value={firstName} onChange={(e) => setFirstName(e.target.value)} />
				<TextField id="outlined-basic" label="Prénom" variant="outlined"
					value={lastName} onChange={(e) => setLastName(e.target.value)} />
				<Button variant="contained" size="large" onClick={() => {
					dispatch({ type: "addCandidate", value: lastName + " " + firstName})
					setFirstName("")
					setLastName("")
				}}>Ajouter</Button>
			</Box>
		</div>
	)
}
