import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
				<h1>
					End-to-end encrypted<br />
					Formally verified<br />
					Election app
				</h1>
      </header>

			<h2>Setup election:</h2>
			<p>
				1. Add candidates
				<br />
				2. Add voters
				<br/>
				3. Start election
			</p>

			<h2>Vote:</h2>
			<p>
				1. Login
				2. Vote (Select + send)
			</p>
    </div>
  );
}

export default App;
