import { Box, Container } from "@mui/material";
import {
  BrowserRouter,
  Routes,
  Route,
} from "react-router-dom";
import Home from './pages/Home.jsx'
import useReducer from './state.js'


function App() {
	const [state, dispatch] = useReducer()

  return (
		<Container fixed>
			<Box
			  display="flex"
			  justifyContent="center"
			  alignItems="center"
			  minHeight="30vh"
			>
				<h1>
					Scrutin:<br />
					end-to-end encrypted<br />
					verifiable election app
				</h1>
			</Box>
			<BrowserRouter>
				<Routes>
					<Route path="/" element={<Home state={state} dispatch={dispatch} />} />
				</Routes>
			</BrowserRouter>
    </Container>
  );
}

export default App;
