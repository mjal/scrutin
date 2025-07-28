import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import ElectionNew from './pages/ElectionNew';
import ElectionView from './pages/ElectionView';
import Verification from './pages/Verification';
import ElectionIndex from './pages/ElectionIndex';
import Login from './pages/Login';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/login" element={<Login />} />
        <Route path="/verify" element={<Verification />} />
        <Route path="/elections" element={<ElectionIndex />} />
        <Route path="/elections/new" element={<ElectionNew />} />
        <Route path="/elections/:uuid" element={<ElectionView />} />
      </Routes>
    </Router>
  );
}

export default App;
