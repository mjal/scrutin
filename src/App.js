import logo from './logo.svg';
import './App.css';
import {
  BrowserRouter,
  Routes,
  Route,
} from "react-router-dom";
import Home from './pages/Home.jsx'
import CandidateList from './pages/CandidateList.jsx'

function App() {
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
					<Route path="/" element={<Home />} />
					<Route path="/candidates" element={<CandidateList />} />
					<Route path="/voters" element={<VoterList />} />
				</Routes>
			</BrowserRouter>
    </div>
  );
}

export default App;
