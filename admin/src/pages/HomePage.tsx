import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const HomePage: React.FC = () => {
  const navigate = useNavigate();

  useEffect(() => {
    // Check if user is logged in
    const logged = localStorage.getItem('logged');
    const authCode = localStorage.getItem('auth_code');
    
    if (logged && authCode) {
      // User is logged, redirect to elections
      navigate('/elections');
    } else {
      // User is not logged, redirect to login
      navigate('/login');
    }
  }, [navigate]);

  return null;
};

export default HomePage;
