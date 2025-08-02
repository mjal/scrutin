import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import ElectionNewPage from './pages/ElectionNewPage';
import ElectionViewPage from './pages/ElectionViewPage';
import VerificationPage from './pages/VerificationPage';
import ElectionIndexPage from './pages/ElectionIndexPage';
import LoginPage from './pages/LoginPage';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/verify" element={<VerificationPage />} />
        <Route path="/elections" element={<ElectionIndexPage />} />
        <Route path="/elections/new" element={<ElectionNewPage />} />
        <Route path="/elections/:uuid" element={<ElectionViewPage />} />
      </Routes>
    </Router>
  );
}

export default App;
