import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import NewElectionPage from './pages/NewElectionPage';
import ElectionViewPage from './pages/ElectionViewPage';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/elections/new" element={<NewElectionPage />} />
        <Route path="/elections/:uuid" element={<ElectionViewPage />} />
      </Routes>
    </Router>
  );
}

export default App;
