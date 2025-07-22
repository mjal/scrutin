import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Container,
  Paper,
  Typography,
  TextField,
  Button,
  FormControl,
  FormLabel,
  RadioGroup,
  FormControlLabel,
  Radio,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  Box,
  Stack,
  IconButton,
  Chip
} from '@mui/material';
import { DateTimePicker } from '@mui/x-date-pickers/DateTimePicker';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import HelpOutlineIcon from '@mui/icons-material/HelpOutline';
import AddIcon from '@mui/icons-material/Add';
import DeleteIcon from '@mui/icons-material/Delete';
import dayjs from 'dayjs';

import { ElectionData } from '../types';
import { Question, Setup, Election, Trustee, Point, Zq } from 'sirona';
import HelpDialog from '../components/HelpDialog';
import { config } from '../config';

const NewElectionPage: React.FC = () => {
  const navigate = useNavigate();
  
  // Single state object containing all election data
  const [state, setState] = useState<Election.t>({
    version: 1,
    description: "",
    name: "",
    group: "Ed25519",
    public_key: Point.zero,
    questions : [
      {
        question: '',
        answers: ['', ''],
        min: 1,
        max: 1
      }
    ],
    uuid: "",
    votingMethod: 'uninominal',
    access: 'open',
    startDate: undefined,
    endDate: undefined,
  });

  // Help dialog states
  const [helpDialog, setHelpDialog] = useState<{
    open: boolean;
    title: string;
    content: string;
  }>({
    open: false,
    title: '',
    content: ''
  });

  // Email input state
  const [emailInput, setEmailInput] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!isFormValid()) {
      return;
    }

    const privkey = Zq.rand(); // Generate a random private key
    const [, serializedTrustee] = Trustee.generateFromPriv(privkey);
    const trustee = Trustee.parse(serializedTrustee);
    const trustees = [trustee];

    console.log('Generated trustees:', trustees);

    // Create election using sirona
    let election = Election.create(
      state.description || "",
      state.name,
      trustees,
      state.questions
    );
    election = {...state, ...election};

    console.log('Election created successfully:', election);

    const setup : Setup.t = {
      election,
      trustees: [trustee],
      credentials: []
    };
    
    console.log('Setup:', setup);

    const emailRegex = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g;
    let emails = Array.from(new Set(emailInput.match(emailRegex) || []));
    emails = Array.from(new Set(emails.map(email => email.trim())));

    const response = await fetch(`${config.server.url}/${election.uuid}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        setup: Setup.serialize(setup),
        emails
      }),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const result = await response.json();
    console.log('Election saved to server:', result);

    // Redirect to the election view page
    navigate(`/elections/${result.uuid}`);
  };

  // Validation function
  const isFormValid = () => {
    // Check if title is not empty
    if (!state.name.trim()) {
      return false;
    }

    // If multiple questions, check that each has a non-empty question name
    if (state.questions.length > 1) {
      for (const question of state.questions) {
        const questionH = question as Question.QuestionH.t;
        if (!questionH.question.trim()) {
          return false;
        }
      }
    }

    for (const question of state.questions) {
      const questionH = question as Question.QuestionH.t;
      const nonEmptyAnswers = questionH.answers.filter(answer => answer.trim() !== '');
      if (nonEmptyAnswers.length < 2) {
        return false;
      }
    }

    return true;
  };

  // Question management functions
  const addQuestion = () => {
    setState(prev => ({
      ...prev,
      questions: [
        ...prev.questions,
        {
          question: '',
          answers: ['', ''],
          min: 1,
          max: 1
        }
      ]
    }));
  };

  const removeQuestion = (index: number) => {
    setState(prev => ({
      ...prev,
      questions: prev.questions.filter((_, i) => i !== index)
    }));
  };

  const updateQuestion = (index: number, field: keyof Question.QuestionH.t, value: any) => {
    setState(prev => ({
      ...prev,
      questions: prev.questions.map((q, i) => 
        i === index ? { ...q, [field]: value } : q
      )
    }));
  };

  const addAnswer = (questionIndex: number) => {
    setState(prev => ({
      ...prev,
      questions: prev.questions.map((q, i) => {
        const qh = q as Question.QuestionH.t;
        return i === questionIndex ? { ...q, answers: [...qh.answers, ''] } : q;
      })
    }));
  };

  const removeAnswer = (questionIndex: number, answerIndex: number) => {
    setState(prev => ({
      ...prev,
      questions: prev.questions.map((q, i) => {
        const qh = q as Question.QuestionH.t;
        return i === questionIndex ? { 
          ...q, 
          answers: qh.answers.filter((_, ai) => ai !== answerIndex) 
        } : q
        }
      )
    }));
  };

  const updateAnswer = (questionIndex: number, answerIndex: number, value: string) => {
    setState(prev => ({
      ...prev,
      questions: prev.questions.map((q, i) => {
        const qh = q as Question.QuestionH.t;
        return i === questionIndex ? { 
          ...q, 
          answers: qh.answers.map((a, ai) => ai === answerIndex ? value : a)
        } : q
      })
    }));
  };

  const handleEmailTextChange = (emailText: string) => {
    setEmailInput(emailText);
  };

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Paper elevation={3} sx={{ p: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Créer une élection
        </Typography>
        
        <Box component="form" onSubmit={handleSubmit}>
          <Stack spacing={3}>
            <TextField
              label="Titre"
              value={state.name}
              onChange={(e) => setState(prev => ({ ...prev, name: e.target.value }))}
              required
              fullWidth
              placeholder="Nom de l'élection"
            />

            <TextField
              label="Description (optionnelle)"
              value={state.description}
              onChange={(e) => setState(prev => ({ ...prev, description: e.target.value }))}
              multiline
              rows={3}
              fullWidth
              placeholder="Description de l'élection"
            />

            {/* Questions Section */}
            <Box>
              <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                <Typography variant="h6">Questions</Typography>
                <Button
                  startIcon={<AddIcon />}
                  onClick={addQuestion}
                  variant="outlined"
                  size="small"
                >
                  Ajouter une question
                </Button>
              </Box>

              <Stack spacing={3}>
                {state.questions.map((question, questionIndex) => (
                  <Paper 
                    key={questionIndex} 
                    elevation={1} 
                    sx={{ p: 3, border: '1px solid #e0e0e0' }}
                  >
                    <Box display="flex" justifyContent="space-between" alignItems="flex-start">
                      {state.questions.length > 1 && (
                        <Box mb={2}>
                          <Chip
                            label={`Question ${questionIndex + 1}`} 
                            size="small" 
                            color="primary" 
                            variant="outlined"
                          />
                        </Box>
                      )}
                      {state.questions.length > 1 && (
                        <IconButton
                          onClick={() => removeQuestion(questionIndex)}
                          size="small"
                          color="error"
                        >
                          <DeleteIcon />
                        </IconButton>
                      )}
                    </Box>

                    <Stack spacing={2}>
                      {state.questions.length > 1 && (
                        <TextField
                          label="Nom de la question"
                          value={(question as Question.QuestionH.t).question}
                          onChange={(e) => updateQuestion(questionIndex, 'question', e.target.value)}
                          required
                          fullWidth
                          placeholder="ex: Qui voulez-vous élire ?"
                        />
                      )}

                      <Box>
                        <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                          <Typography variant="subtitle2" color="text.secondary">
                            Options (au moins 2)
                          </Typography>
                          <Button
                            startIcon={<AddIcon />}
                            onClick={() => addAnswer(questionIndex)}
                            size="small"
                            variant="text"
                          >
                            Ajouter une option
                          </Button>
                        </Box>

                        <Stack spacing={1}>
                          {
                          (question as Question.QuestionH.t).answers.map((answer, answerIndex) => (
                            <Box key={answerIndex} display="flex" gap={1} alignItems="center">
                              <TextField
                                value={answer}
                                onChange={(e) => updateAnswer(questionIndex, answerIndex, e.target.value)}
                                fullWidth
                                size="small"
                                placeholder={`Option ${answerIndex + 1}`}
                              />
                              {(question as Question.QuestionH.t).answers.length > 2 && (
                                <IconButton
                                  onClick={() => removeAnswer(questionIndex, answerIndex)}
                                  size="small"
                                  color="error"
                                >
                                  <DeleteIcon fontSize="small" />
                                </IconButton>
                              )}
                            </Box>
                          ))}
                        </Stack>
                      </Box>
                    </Stack>
                  </Paper>
                ))}
              </Stack>
            </Box>

            <Accordion>
              <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                <Typography>Dates</Typography>
              </AccordionSummary>
              <AccordionDetails>
                <Stack spacing={3}>
                  <DateTimePicker
                    label="Date de début (optionnelle)"
                    value={state.startDate ? dayjs(state.startDate) : null}
                    onChange={(newValue) =>
                      setState(prev => ({
                        ...prev,
                        startDate: newValue ? newValue.toDate() : undefined
                      }))
                    }
                    slotProps={{
                      textField: {
                        fullWidth: true
                      }
                    }}
                  />

                  <DateTimePicker
                    label="Date de fin (optionnelle)"
                    value={state.endDate ? dayjs(state.endDate) : null}
                    onChange={(newValue) =>
                      setState(prev => ({
                        ...prev,
                        endDate: newValue ? newValue.toDate() : undefined
                      }))
                    }
                    slotProps={{
                      textField: {
                        fullWidth: true
                      }
                    }}
                  />
                </Stack>
              </AccordionDetails>
            </Accordion>
            <Accordion>
              <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                <Typography>Avancé</Typography>
              </AccordionSummary>
              <AccordionDetails>
                <Stack spacing={3}>
                  <FormControl component="fieldset">
                    <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                      <FormLabel component="legend">Type d'invitation</FormLabel>
                      <IconButton 
                        onClick={() => setHelpDialog({
                          open: true,
                          title: "Type d'invitation",
                          content: "• Par lien : Génère un lien unique à partager avec les électeurs. Simple et pratique pour les élections ouvertes.\n\n• Par email : Envoie automatiquement les invitations par email à une liste de destinataires. Recommandé pour les élections fermées avec liste d'électeurs définie."
                        })}
                        sx={{ 
                          color: 'primary.main',
                          '&:hover': { backgroundColor: 'primary.light', color: 'white' }
                        }}
                      >
                        <HelpOutlineIcon />
                      </IconButton>
                    </Box>
                    <RadioGroup
                      value={state.access}
                      onChange={(e) => setState(prev => ({ ...prev, invitationMethod: e.target.value }))}
                      row
                    >
                      <FormControlLabel
                        value="open"
                        control={<Radio />}
                        label="Par lien"
                      />
                      <FormControlLabel
                        value="closed"
                        control={<Radio />}
                        label="Par email"
                      />
                    </RadioGroup>

                    {/* Email list section - only show when email is selected */}
                    {state.access === 'open' && (
                      <Box sx={{ mt: 2 }}>
                        {emailInput.split(/\r?\n/).length >= 2 && (
                          <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                            Liste des électeurs ({emailInput.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g)?.length || 0} email{(emailInput.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g)?.length || 0) !== 1 ? 's' : ''})
                          </Typography>
                        )}
                        
                        <TextField
                          placeholder="Collez vos emails ici (un par ligne)&#10;Exemple:&#10;user1@example.com&#10;user2@example.com"
                          value={emailInput}
                          onChange={(e) => handleEmailTextChange(e.target.value)}
                          multiline
                          rows={4}
                          fullWidth
                          sx={{ mb: 2 }}
                        />
                      </Box>
                    )}
                  </FormControl>

                  <FormControl component="fieldset">
                    <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                      <FormLabel component="legend">Type de scrutin</FormLabel>
                      <IconButton 
                        onClick={() => setHelpDialog({
                          open: true,
                          title: "Type de scrutin",
                          content: "• Scrutin uninominal : Les électeurs choisissent une seule option parmi celles proposées. Le candidat avec le plus de voix l'emporte.\n\n• Jugement majoritaire : Les électeurs évaluent chaque option sur une échelle (ex: Très bien, Bien, Assez bien, Passable, Insuffisant, À rejeter). L'option avec la meilleure mention majoritaire gagne."
                        })}
                        sx={{ 
                          color: 'primary.main',
                          '&:hover': { backgroundColor: 'primary.light', color: 'white' }
                        }}
                      >
                        <HelpOutlineIcon />
                      </IconButton>
                    </Box>
                    <RadioGroup
                      value={state.votingMethod}
                      onChange={(e) => setState(prev => ({ ...prev, votingMethod: e.target.value as 'uninominal' | 'majorityJudgement' }))}
                      row
                    >
                      <FormControlLabel
                        value="uninominal"
                        control={<Radio />}
                        label="Scrutin uninominal"
                      />
                      <FormControlLabel
                        value="majorityJudgement"
                        control={<Radio />}
                        label="Jugement majoritaire"
                      />
                    </RadioGroup>
                  </FormControl>
                </Stack>
              </AccordionDetails>
            </Accordion>

            <Box>
              <Button
                type="submit"
                variant="contained"
                size="large"
                disabled={!isFormValid()}
                sx={{ mt: 3 }}
                fullWidth
              >
                Créer l'élection
              </Button>
              
                {!isFormValid() && (
                <Typography 
                  variant="caption" 
                  color="error" 
                  sx={{ mt: 1, display: 'block', textAlign: 'center' }}
                >
                  {!state.name.trim() && "Le titre est obligatoire. "}
                  {state.questions.length > 1 && state.questions.some(q => !(q as Question.QuestionH.t).question.trim()) && 
                  "Le nom de chaque question est obligatoire quand il y a plusieurs questions. "
                  }
                  {state.questions.some(q => (q as Question.QuestionH.t).answers.filter(a => a.trim() !== '').length < 2) && 
                  "Chaque question doit avoir au moins 2 options non vides."
                  }
                </Typography>
                )}
            </Box>
          </Stack>
        </Box>
      </Paper>

      {/* Help Dialog */}
      <HelpDialog
        open={helpDialog.open}
        title={helpDialog.title}
        content={helpDialog.content}
        onClose={() => setHelpDialog(prev => ({ ...prev, open: false }))}
      />
    </Container>
  );
};

export default NewElectionPage;
