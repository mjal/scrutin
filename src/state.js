import { useReducer } from 'react'

const initialState = {
	electionName: "Élection sans nom",
	voters: [],
	candidates: []
}

function reducer(state, action) {
	console.log(action, state)
  switch (action.type) {
    case 'electionName':
      return {...state, electionName: action.value}
    case 'addVoter':
      return {...state, voters: [...new Set([...state.voters, action.voter])]}
    case 'removeVoter':
			const index = state.voters.indexOf(action.value)
			if (index > -1) {
				state.voters.splice(index, 1)
			}
      return {...state, voters: state.value}
    case 'addCandidate':
      return {...state, candidates: [...new Set([...state.candidates, action.value])]}
    default:
      throw new Error()
  }
	console.log(state)
}

export default function() {
	return useReducer(reducer, initialState);
}
