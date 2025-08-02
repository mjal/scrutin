import React, { useState } from 'react';
import { Container, Typography, Button, Box, Paper, TextField } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { config } from '../config';
import Header from '../components/Header';

const Login: React.FC = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleEmailSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email) return;

    setIsLoading(true);
    try {
      const response = await fetch(`${config.server.url}/challenge`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email }),
      });

      if (response.ok) {
        // Store email in localStorage for verification page
        localStorage.setItem('email', email);
        // Navigate to verification page
        navigate('/verify');
      }
    } catch (error) {
      console.error('Error submitting email:', error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <>
      <Header />
      <Container maxWidth="md" sx={{ py: 4 }}>
        <Paper elevation={3} sx={{ p: 4, textAlign: 'center' }}>
          <Typography variant="h3" component="h1" gutterBottom>
            Connexion
          </Typography>
        
          <Typography variant="h6" color="text.secondary" sx={{ mb: 4 }}>
            Entrez votre email pour recevoir un code de vérification
          </Typography>
        
          <Box component="form" onSubmit={handleEmailSubmit} sx={{ mb: 3 }}>
            <TextField
              fullWidth
              label="Votre email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              sx={{ mb: 2 }}
            />
            <Button
              type="submit"
              variant="contained"
              size="large"
              disabled={isLoading || !email}
              sx={{ mr: 2 }}
            >
              {isLoading ? 'Envoi...' : 'Se connecter'}
            </Button>
          </Box>
        </Paper>
      </Container>
    </>
  );
};

export default Login;