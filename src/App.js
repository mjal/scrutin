import './App.css';
import { useReducer } from 'react'
import {
  BrowserRouter,
  Routes,
  Route,
} from "react-router-dom";
import Home from './pages/Home.jsx'
import CandidateList from './pages/CandidateList.jsx'
import VoterList from './pages/VoterList.jsx'

let initialState = {
	voters: [],
	candidates: []
}

function reducer(state, action) {
	console.log(action)
  switch (action.type) {
    case 'addVoter':
      return {...state, voters: [...new Set([...state.voters, action.voter])]}
    case 'removeVoter':
			const index = state.voters.indexOf(action.voter)
			if (index > -1) {
				state.voters.splice(index, 1)
			}
      return {...state, voters: state.voters}
    default:
      throw new Error()
  }
}

function App() {
	const [state, dispatch] = useReducer(reducer, initialState);

  return (
    <div className="App">
      <header className="App-header">
				<h1>
					Scrutin:<br />
					End-to-end encrypted<br />
					Formally verified<br />
					Election app
				</h1>
      </header>
			<BrowserRouter>
				<Routes>
					<Route path="/" element={<Home state={state} dispatch={dispatch} />} />
					<Route path="/candidates" element={<CandidateList state={state} dispatch={dispatch} />} />
					<Route path="/voters" element={<VoterList state={state} dispatch={dispatch} />} />
				</Routes>
			</BrowserRouter>
    </div>
  );
}

export default App;
