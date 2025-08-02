import React from 'react';
import {
  Box,
  Typography,
  Stack,
  Paper,
  Chip,
  List,
  ListItem,
  ListItemText,
  Alert
} from '@mui/material';
import {
  InfoOutlined,
  QuizOutlined,
  ScheduleOutlined,
  HowToVoteOutlined,
  EmailOutlined,
  LinkOutlined
} from '@mui/icons-material';
import { Election, Question } from 'sirona';
import dayjs from 'dayjs';

interface ReviewStepProps {
  state: Election.t & { access: string; votingMethod: string };
  emailInput: string;
  isValid: boolean;
  validationErrors: string[];
}

const ReviewStep: React.FC<ReviewStepProps> = ({ 
  state, 
  emailInput, 
  isValid, 
  validationErrors 
}) => {
  const emailCount = emailInput.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g)?.length || 0;

  return (
    <Paper elevation={1} sx={{ p: 4 }}>
      <Typography variant="h5" sx={{ mb: 3, fontWeight: 600 }}>
        Vérification finale
      </Typography>
      
      <Typography variant="body2" color="text.secondary" sx={{ mb: 4 }}>
        Vérifiez les détails de votre élection avant de la créer.
      </Typography>

      <Stack spacing={4}>
        {/* Validation Errors */}
        {!isValid && (
          <Alert severity="error" sx={{ mb: 2 }}>
            <Typography variant="subtitle2" sx={{ mb: 1 }}>
              Veuillez corriger les erreurs suivantes :
            </Typography>
            <List dense>
              {validationErrors.map((error, index) => (
                <ListItem key={index} sx={{ py: 0 }}>
                  <ListItemText primary={`• ${error}`} />
                </ListItem>
              ))}
            </List>
          </Alert>
        )}

        {/* Basic Information */}
        <Box>
          <Box display="flex" alignItems="center" gap={1} mb={2}>
            <InfoOutlined color="primary" />
            <Typography variant="h6" fontWeight={500}>
              Informations de base
            </Typography>
          </Box>
          <Paper elevation={0} sx={{ p: 3, bgcolor: 'grey.50' }}>
            <Stack spacing={2}>
              <Box>
                <Typography variant="subtitle2" color="text.secondary">
                  Titre
                </Typography>
                <Typography variant="body1" fontWeight={500}>
                  {state.name || "Non défini"}
                </Typography>
              </Box>
              {state.description && (
                <Box>
                  <Typography variant="subtitle2" color="text.secondary">
                    Description
                  </Typography>
                  <Typography variant="body2">
                    {state.description}
                  </Typography>
                </Box>
              )}
            </Stack>
          </Paper>
        </Box>

        {/* Questions */}
        <Box>
          <Box display="flex" alignItems="center" gap={1} mb={2}>
            <QuizOutlined color="primary" />
            <Typography variant="h6" fontWeight={500}>
              Questions ({state.questions.length})
            </Typography>
          </Box>
          <Stack spacing={2}>
            {state.questions.map((question, index) => (
              <Paper key={index} elevation={0} sx={{ p: 3, bgcolor: 'grey.50' }}>
                <Stack spacing={2}>
                  {state.questions.length > 1 && (
                    <Chip
                      label={`Question ${index + 1}`}
                      size="small"
                      color="primary"
                      variant="outlined"
                    />
                  )}
                  {state.questions.length > 1 && (
                    <Box>
                      <Typography variant="subtitle2" color="text.secondary">
                        Question
                      </Typography>
                      <Typography variant="body1">
                        {(question as Question.QuestionH.t).question || "Question sans nom"}
                      </Typography>
                    </Box>
                  )}
                  <Box>
                    <Typography variant="subtitle2" color="text.secondary">
                      Options ({(question as Question.QuestionH.t).answers.filter(a => a.trim()).length})
                    </Typography>
                    <Stack spacing={0.5} sx={{ mt: 1 }}>
                      {(question as Question.QuestionH.t).answers
                        .filter(answer => answer.trim())
                        .map((answer, answerIndex) => (
                          <Typography key={answerIndex} variant="body2">
                            • {answer}
                          </Typography>
                        ))}
                    </Stack>
                  </Box>
                </Stack>
              </Paper>
            ))}
          </Stack>
        </Box>

        {/* Schedule */}
        <Box>
          <Box display="flex" alignItems="center" gap={1} mb={2}>
            <ScheduleOutlined color="primary" />
            <Typography variant="h6" fontWeight={500}>
              Calendrier
            </Typography>
          </Box>
          <Paper elevation={0} sx={{ p: 3, bgcolor: 'grey.50' }}>
            <Stack spacing={2}>
              <Box>
                <Typography variant="subtitle2" color="text.secondary">
                  Date de début
                </Typography>
                <Typography variant="body2">
                  {state.startDate 
                    ? dayjs(state.startDate).format('DD/MM/YYYY à HH:mm')
                    : "Immédiatement"}
                </Typography>
              </Box>
              <Box>
                <Typography variant="subtitle2" color="text.secondary">
                  Date de fin
                </Typography>
                <Typography variant="body2">
                  {state.endDate 
                    ? dayjs(state.endDate).format('DD/MM/YYYY à HH:mm')
                    : "Aucune limite"}
                </Typography>
              </Box>
            </Stack>
          </Paper>
        </Box>

        {/* Access and Voting Method */}
        <Box>
          <Box display="flex" alignItems="center" gap={1} mb={2}>
            <HowToVoteOutlined color="primary" />
            <Typography variant="h6" fontWeight={500}>
              Configuration
            </Typography>
          </Box>
          <Paper elevation={0} sx={{ p: 3, bgcolor: 'grey.50' }}>
            <Stack spacing={2}>
              <Box>
                <Typography variant="subtitle2" color="text.secondary">
                  Type d'accès
                </Typography>
                <Box display="flex" alignItems="center" gap={1} mt={0.5}>
                  {state.access === 'open' ? (
                    <>
                      <LinkOutlined fontSize="small" color="primary" />
                      <Typography variant="body2">
                        Par lien public
                      </Typography>
                    </>
                  ) : (
                    <>
                      <EmailOutlined fontSize="small" color="primary" />
                      <Typography variant="body2">
                        Par email privé ({emailCount} destinataire{emailCount !== 1 ? 's' : ''})
                      </Typography>
                    </>
                  )}
                </Box>
              </Box>
              <Box>
                <Typography variant="subtitle2" color="text.secondary">
                  Type de scrutin
                </Typography>
                <Typography variant="body2">
                  {state.votingMethod === 'uninominal' 
                    ? 'Scrutin uninominal' 
                    : 'Jugement majoritaire'}
                </Typography>
              </Box>
            </Stack>
          </Paper>
        </Box>

        {isValid && (
          <Alert severity="success">
            <Typography variant="body2">
              Votre élection est prête à être créée ! Cliquez sur "Créer l'élection" pour continuer.
            </Typography>
          </Alert>
        )}
      </Stack>
    </Paper>
  );
};

export default ReviewStep;