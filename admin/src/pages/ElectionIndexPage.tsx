import React, { useState, useEffect } from 'react';
import { Container, Typography, Paper, List, ListItem, ListItemText, Button, Box } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { config } from '../config';
import Header from '../components/Header';

interface Election {
  id: string;
  name: string;
  description?: string;
  status: string;
}

const ElectionIndex: React.FC = () => {
  const navigate = useNavigate();
  const [elections, setElections] = useState<{ uuid: string }[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const loadElections = async () => {
      try {
        const email = localStorage.getItem('email');
        const authCode = localStorage.getItem('auth_code');
        
        if (!email || !authCode) {
          navigate('/');
          return;
        }

        const response = await fetch(`${config.server.url}/elections`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ 
            email: email,
            auth_code: authCode 
          }),
        });

        if (response.ok) {
          const res = await response.json();
          setElections(res.elections);
        } else {
          console.error('Failed to fetch elections:', response.status);
          if (response.status === 401) {
            navigate('/');
          }
        }
      } catch (error) {
        console.error('Error loading elections:', error);
      } finally {
        setIsLoading(false);
      }
    };

    loadElections();
  }, []);

  if (isLoading) {
    return (
      <Container maxWidth="md" sx={{ py: 4 }}>
        <Typography>Chargement des élections...</Typography>
      </Container>
    );
  }

  return (
    <>
      <Header />
      <Container maxWidth="md" sx={{ py: 4 }}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h3" component="h1" gutterBottom>
          Mes Élections
        </Typography>
        
        {elections.length === 0 ? (
          <Box sx={{ textAlign: 'center', py: 4 }}>
            <Typography variant="h6" color="text.secondary" sx={{ mb: 2 }}>
              Aucune élection trouvée
            </Typography>
          </Box>
        ) : (
          <List>
            {elections.map((election) => (
              <ListItem key={election.uuid} divider>
                <ListItemText
                  primary={election.uuid}
                />
                <Button
                  variant="outlined"
                  onClick={() => navigate(`/elections/${election.uuid}`)}
                >
                  Voir
                </Button>
              </ListItem>
            ))}
          </List>
        )}

        <Box sx={{ textAlign: 'center' }}>
          <Button
            variant="contained"
            onClick={() => navigate('/elections/new')}
          >
            Créer une nouvelle élection
          </Button>
        </Box>
          
        <Box sx={{ mt: 3, display: 'flex', justifyContent: 'space-between' }}>
          <Button
            variant="text"
            onClick={() => navigate('/')}
          >
            Retour à l'accueil
          </Button>
        </Box>
      </Paper>
    </Container>
    </>
  );
};

export default ElectionIndex;