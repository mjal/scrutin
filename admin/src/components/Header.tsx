import React from 'react';
import { AppBar, Toolbar, Typography, Button, Box } from '@mui/material';
import { useNavigate } from 'react-router-dom';

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
    <AppBar position="static">
      <Toolbar>
        <Typography 
          variant="h6" 
          component="div" 
          sx={{ flexGrow: 1, cursor: 'pointer' }}
          onClick={handleHomeClick}
        >
          Scrutin
        </Typography>
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
              <Button color="inherit" onClick={handleLogout}>
                Déconnexion
              </Button>
            </>
          ) : (
            <Button color="inherit" onClick={handleLogin}>
              Connexion
            </Button>
          )}
        </Box>
      </Toolbar>
    </AppBar>
  );
};

export default Header;