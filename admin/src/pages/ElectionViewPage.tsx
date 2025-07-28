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
  ListItemText,
  Link,
  Button
} from '@mui/material';
import { OpenInNew as OpenInNewIcon } from '@mui/icons-material';
import QRCode from 'react-qr-code';
import { config } from '../config';
import { Question, Setup, Election, Trustee, Point, Zq } from 'sirona';

const ElectionViewPage: React.FC = () => {
  const { uuid } = useParams<{ uuid: string }>();
  const [election, setElection] = useState<Election.t | null>(null);
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
        setElection(data.setup.election);
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
            {election.name}
          </Typography>
          
          <Box sx={{ display: 'flex', gap: 1, mb: 2 }}>
            <Chip 
              label={election.votingMethod === 'uninominal' ? 'Scrutin uninominal' : 'Jugement majoritaire'} 
              variant="outlined"
              size="small"
            />
            <Chip 
              label={election.access === 'open' ? 'Ouverte' : 'Fermée'} 
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
            Lien de vote
          </Typography>
          <Box sx={{ mb: 2 }}>
            <Link 
              href={`${config.vote.url}/elections/${uuid}/booth`} 
              target="_blank" 
              rel="noopener noreferrer"
              sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}
            >
              {config.vote.url}/elections/{uuid}/booth
              <OpenInNewIcon fontSize="small" />
            </Link>
            <Button
              variant="outlined"
              size="small"
              onClick={() => navigator.clipboard.writeText(`${config.vote.url}/elections/${uuid}/booth`)}
              sx={{ mr: 2 }}
            >
              Copier le lien
            </Button>
          </Box>
          <Box sx={{ mt: 2, p: 2, bgcolor: 'background.paper', border: 1, borderColor: 'divider', borderRadius: 1 }}>
            <Typography variant="subtitle2" gutterBottom>
              Code QR
            </Typography>
            <QRCode
              size={128}
              style={{ height: "auto", maxWidth: "100%", width: "100%" }}
              value={`${config.vote.url}/elections/${uuid}/booth`}
              viewBox={`0 0 128 128`}
            />
          </Box>
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
            {election.questions.map((question, index) => {
              let q = (question as Question.QuestionH.t);

              return <ListItem key={index} sx={{ flexDirection: 'column', alignItems: 'flex-start' }}>
                <ListItemText
                  primary={
                    <Typography variant="h6" component="div">
                      Question {index + 1}
                      {q.question && `: ${q.question}`}
                    </Typography>
                  }
                  secondary={
                    <Box sx={{ mt: 1 }}>
                      <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
                        Choix disponibles :
                      </Typography>
                      <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                        {q.answers.map((answer, answerIndex) => (
                          <Chip
                            key={answerIndex}
                            label={answer}
                            variant="outlined"
                            size="small"
                          />
                        ))}
                      </Box>
                      <Typography variant="caption" color="text.secondary" sx={{ mt: 1, display: 'block' }}>
                        Min: {q.min}, Max: {q.max}
                      </Typography>
                    </Box>
                  }
                />
                {index < election.questions.length - 1 && <Divider sx={{ width: '100%', mt: 2 }} />}
              </ListItem>
            })}
          </List>
        </Box>
      </Paper>
    </Container>
  );
};

export default ElectionViewPage;
