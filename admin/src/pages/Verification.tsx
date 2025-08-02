import React, { useState } from 'react';
import { Container, Typography, Button, Box, Paper, TextField } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { config } from '../config';
import Header from '../components/Header';
import { useLocalStorage } from '../hooks';

const Verification: React.FC = () => {
  const navigate = useNavigate();
  const [verificationCode, setVerificationCode] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [email, setEmail] = useLocalStorage('email', '');
  const [, setAuthCode] = useLocalStorage('auth_code', '');
  const [, setLogged] = useLocalStorage('logged', '');

  const handleVerificationSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!verificationCode) return;

    setIsLoading(true);
    try {
      // Get the email from localStorage (set from HomePage)
      if (!email) {
        console.error('No email found in localStorage');
        navigate('/');
        return;
      }

      // Send POST request to verify email + auth_code
      const response = await fetch(`${config.server.url}/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ 
          email: email,
          auth_code: verificationCode
        }),
      });

      if (response.status === 200) {
        // Store both email and auth_code in localStorage
        setEmail(email);
        setAuthCode(verificationCode);
        setLogged("true");
        
        // Navigate to ElectionIndexPage
        navigate('/elections');
      } else {
        console.error('Verification failed:', response.status);
      }
    } catch (error) {
      console.error('Error verifying code:', error);
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
          Vérification
        </Typography>
        
        <Typography variant="h6" color="text.secondary" sx={{ mb: 4 }}>
          Entrez le code de vérification envoyé par email
        </Typography>
        
        <Box component="form" onSubmit={handleVerificationSubmit} sx={{ mb: 3 }}>
          <TextField
            fullWidth
            label="Code de vérification"
            type="text"
            value={verificationCode}
            onChange={(e) => setVerificationCode(e.target.value)}
            required
            sx={{ mb: 2 }}
            inputProps={{ maxLength: 6 }}
          />
          <Button
            type="submit"
            variant="contained"
            size="large"
            disabled={isLoading || !verificationCode}
          >
            {isLoading ? 'Vérification...' : 'Vérifier'}
          </Button>
        </Box>
        
        <Button
          variant="text"
          onClick={() => navigate('/')}
        >
          Retour à l'accueil
        </Button>
      </Paper>
    </Container>
    </>
  );
};

export default Verification;