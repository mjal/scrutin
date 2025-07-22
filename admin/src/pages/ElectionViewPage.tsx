import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import {
  Container,
  Paper,
  Typography,
  CircularProgress,
  Alert,
  Box,
  Chip,
  Divider,
  List,
  ListItem,
  ListItemText
} from '@mui/material';
import { config } from '../config';

interface ElectionData {
  uuid: string;
  title: string;
  description?: string;
  questions: Array<{
    question: string;
    answers: string[];
    min: number;
    max: number;
  }>;
  startDate?: string;
  endDate?: string;
  invitationMethod: string;
  votingMethod: string;
  status: string;
}

const ElectionViewPage: React.FC = () => {
  const { uuid } = useParams<{ uuid: string }>();
  const [election, setElection] = useState<ElectionData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchElection = async () => {
      if (!uuid) {
        setError('UUID de l\'élection manquant');
        setLoading(false);
        return;
      }

      try {
        const response = await fetch(`${config.server.url}/${uuid}`);
        
        if (!response.ok) {
          throw new Error(`Erreur ${response.status}: ${response.statusText}`);
        }

        const data = await response.json();
        setElection(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Erreur inconnue');
      } finally {
        setLoading(false);
      }
    };

    fetchElection();
  }, [uuid]);

  if (loading) {
    return (
      <Container maxWidth="md" sx={{ py: 4, textAlign: 'center' }}>
        <CircularProgress />
        <Typography variant="h6" sx={{ mt: 2 }}>
          Chargement de l'élection...
        </Typography>
      </Container>
    );
  }

  if (error) {
    return (
      <Container maxWidth="md" sx={{ py: 4 }}>
        <Alert severity="error">
          <Typography variant="h6">Erreur lors du chargement</Typography>
          <Typography>{error}</Typography>
        </Alert>
      </Container>
    );
  }

  if (!election) {
    return (
      <Container maxWidth="md" sx={{ py: 4 }}>
        <Alert severity="warning">
          <Typography variant="h6">Élection non trouvée</Typography>
          <Typography>L'élection avec l'UUID "{uuid}" n'existe pas.</Typography>
        </Alert>
      </Container>
    );
  }

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Box sx={{ mb: 3 }}>
          <Typography variant="h4" component="h1" gutterBottom>
            {election.title}
          </Typography>
          
          <Box sx={{ display: 'flex', gap: 1, mb: 2 }}>
            <Chip 
              label={election.status} 
              color={election.status === 'active' ? 'success' : 'default'}
              size="small"
            />
            <Chip 
              label={election.votingMethod === 'uninominal' ? 'Scrutin uninominal' : 'Jugement majoritaire'} 
              variant="outlined"
              size="small"
            />
            <Chip 
              label={election.invitationMethod === 'email' ? 'Par email' : 'Par lien'} 
              variant="outlined"
              size="small"
            />
          </Box>

          <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
            UUID: {election.uuid}
          </Typography>

          {election.description && (
            <Typography variant="body1" sx={{ mb: 3 }}>
              {election.description}
            </Typography>
          )}
        </Box>

        <Divider sx={{ my: 3 }} />

        <Box sx={{ mb: 3 }}>
          <Typography variant="h6" gutterBottom>
            Dates
          </Typography>
          <Box sx={{ display: 'flex', gap: 2, flexWrap: 'wrap' }}>
            {election.startDate && (
              <Typography variant="body2">
                <strong>Début :</strong> {new Date(election.startDate).toLocaleString('fr-FR')}
              </Typography>
            )}
            {election.endDate && (
              <Typography variant="body2">
                <strong>Fin :</strong> {new Date(election.endDate).toLocaleString('fr-FR')}
              </Typography>
            )}
            {!election.startDate && !election.endDate && (
              <Typography variant="body2" color="text.secondary">
                Aucune date spécifiée
              </Typography>
            )}
          </Box>
        </Box>

        <Divider sx={{ my: 3 }} />

        <Box>
          <Typography variant="h6" gutterBottom>
            Questions ({election.questions.length})
          </Typography>
          
          <List>
            {election.questions.map((question, index) => (
              <ListItem key={index} sx={{ flexDirection: 'column', alignItems: 'flex-start' }}>
                <ListItemText
                  primary={
                    <Typography variant="h6" component="div">
                      Question {index + 1}
                      {question.question && `: ${question.question}`}
                    </Typography>
                  }
                  secondary={
                    <Box sx={{ mt: 1 }}>
                      <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                        Choix disponibles :
                      </Typography>
                      <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                        {question.answers.map((answer, answerIndex) => (
                          <Chip
                            key={answerIndex}
                            label={answer}
                            variant="outlined"
                            size="small"
                          />
                        ))}
                      </Box>
                      <Typography variant="caption" color="text.secondary" sx={{ mt: 1, display: 'block' }}>
                        Min: {question.min}, Max: {question.max}
                      </Typography>
                    </Box>
                  }
                />
                {index < election.questions.length - 1 && <Divider sx={{ width: '100%', mt: 2 }} />}
              </ListItem>
            ))}
          </List>
        </Box>
      </Paper>
    </Container>
  );
};

export default ElectionViewPage;
