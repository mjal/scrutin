import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useLocalStorage } from '../hooks';

const HomePage: React.FC = () => {
  const navigate = useNavigate();
  const [logged] = useLocalStorage('logged', '');
  const [authCode] = useLocalStorage('auth_code', '');

  useEffect(() => {
    // Check if user is logged in
    if (logged && authCode) {
      // User is logged, redirect to elections
      navigate('/elections');
    } else {
      // User is not logged, redirect to login
      navigate('/login');
    }
  }, [navigate, logged, authCode]);

  return null;
};

export default HomePage;
