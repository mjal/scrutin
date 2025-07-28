import React from 'react';
import { AppBar, Toolbar, Typography, Button, Box } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import ScrutinLogo from '../assets/ScrutinLogo';

const Header: React.FC = () => {
  const navigate = useNavigate();
  const email = localStorage.getItem('email');
  const logged = localStorage.getItem('logged');
  const isLoggedIn = Boolean(logged);

  const handleLogin = () => {
    navigate('/login');
  };

  const handleHomeClick = () => {
    navigate('/');
  };

  const handleLogout = () => {
    localStorage.removeItem('email');
    localStorage.removeItem('auth_code');
    localStorage.removeItem('logged');
    navigate('/');
  };

  return (
    <AppBar position="static" sx={{ backgroundColor: 'white', color: 'black', borderBottom: '2px solid #6750a4' }}>
      <Toolbar>
        <Box 
          sx={{ cursor: 'pointer', display: 'flex', alignItems: 'center', marginRight: 'auto' }}
          onClick={handleHomeClick}
        >
          <ScrutinLogo style={{ height: '32px' }} />
        </Box>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
          {isLoggedIn ? (
            <>
              <Typography 
                variant="body2"
                sx={{ cursor: 'pointer' }}
                onClick={handleHomeClick}
              >
                {email}
              </Typography>
              <Button sx={{ color: 'black' }} onClick={handleLogout}>
                Déconnexion
              </Button>
            </>
          ) : (
            <Button sx={{ color: 'black' }} onClick={handleLogin}>
              Connexion
            </Button>
          )}
        </Box>
      </Toolbar>
    </AppBar>
  );
};

export default Header;