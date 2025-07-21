import React, { useState } from 'react';
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
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Divider,
  Chip
} from '@mui/material';
import { DateTimePicker } from '@mui/x-date-pickers/DateTimePicker';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import HelpOutlineIcon from '@mui/icons-material/HelpOutline';
import CloseIcon from '@mui/icons-material/Close';
import AddIcon from '@mui/icons-material/Add';
import DeleteIcon from '@mui/icons-material/Delete';
import dayjs, { Dayjs } from 'dayjs';
import { ElectionState, InvitationMethod } from './types';
import { Question, Election, Trustee, Zq } from 'sirona';

function App() {
  // Single state object containing all election data
  const [state, setState] = useState<ElectionState>({
    title: '',
    desc: '',
    questions: [
      {
        question: '',
        answers: ['', ''],
        min: 1,
        max: 1
      }
    ],
    emails: [],
    invitationMethod: 'lien',
    votingMethod: 'uninominal',
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

    try {
      // Convert form questions to sirona format
      const sironaQuestions = state.questions.map(q => ({
        question: q.question || "Question sans titre",
        answers: q.answers.filter(answer => answer.trim() !== ''),
        min: q.min || 1,
        max: q.max || 1,
        blank: q.blank || false
      }));

      console.log('Creating election with questions:', sironaQuestions);      // Generate trustees for the election (minimum required)
      // Equivalent of ReScript: let (_privkey, serializedTrustee) = Trustee.generateFromPriv(privkey)
      const privkey = Zq.rand(); // Generate a random private key
      const [_privkey, serializedTrustee] = Trustee.generateFromPriv(privkey);
      const trustee = Trustee.parse(serializedTrustee);
      const trustees = [trustee];

      console.log('Generated trustees:', trustees);

      // Create election using sirona
      const election = Election.create(
        state.desc || "",  // description
        state.title,       // name
        trustees,          // trustees
        sironaQuestions    // questions
      );
      
      console.log('Election created successfully:', election);
      
      // Update state with created election
      setState(prev => ({
        ...prev,
        election: election,
        trustees: trustee  // Store the single trustee, not the array
      }));

      // Here you would typically send the election to your backend
      // For now, we'll just log the success
      alert('Élection créée avec succès !');

    } catch (error) {
      console.error('Error creating election:', error);
      const errorMessage = error instanceof Error ? error.message : 'Erreur inconnue';
      alert('Erreur lors de la création de l\'élection: ' + errorMessage);
    }
  };

  // Validation function
  const isFormValid = () => {
    // Check if title is not empty
    if (!state.title.trim()) {
      return false;
    }

    // Check if all questions have at least 2 non-empty choices
    for (const question of state.questions) {
      const nonEmptyAnswers = question.answers.filter(answer => answer.trim() !== '');
      if (nonEmptyAnswers.length < 2) {
        return false;
      }
    }

    return true;
  };

  const openHelp = (title: string, content: string) => {
    setHelpDialog({
      open: true,
      title,
      content
    });
  };

  const closeHelp = () => {
    setHelpDialog(prev => ({ ...prev, open: false }));
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
      questions: prev.questions.map((q, i) => 
        i === questionIndex ? { ...q, answers: [...q.answers, ''] } : q
      )
    }));
  };

  const removeAnswer = (questionIndex: number, answerIndex: number) => {
    setState(prev => ({
      ...prev,
      questions: prev.questions.map((q, i) => 
        i === questionIndex ? { 
          ...q, 
          answers: q.answers.filter((_, ai) => ai !== answerIndex) 
        } : q
      )
    }));
  };

  const updateAnswer = (questionIndex: number, answerIndex: number, value: string) => {
    setState(prev => ({
      ...prev,
      questions: prev.questions.map((q, i) => 
        i === questionIndex ? { 
          ...q, 
          answers: q.answers.map((a, ai) => ai === answerIndex ? value : a)
        } : q
      )
    }));
  };

  // Email management functions
  const parseEmails = (emailText: string) => {
    // Split by common separators and filter valid emails
    const emailRegex = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g;
    const foundEmails = emailText.match(emailRegex) || [];
    
    // Remove duplicates and filter out emails already in the list
    const uniqueEmails = Array.from(new Set(foundEmails));
    const newEmails = uniqueEmails.filter(email => 
      !state.emails.includes(email.trim())
    );
    
    return newEmails;
  };

  const handleEmailTextChange = (emailText: string) => {
    setEmailInput(emailText);
  };

  const parseAndAddEmails = () => {
    const newEmails = parseEmails(emailInput);
    if (newEmails.length > 0) {
      setState(prev => ({
        ...prev,
        emails: [...prev.emails, ...newEmails]
      }));
      setEmailInput(''); // Clear the textarea after parsing
    }
  };

  const removeEmail = (index: number) => {
    setState(prev => ({
      ...prev,
      emails: prev.emails.filter((_, i) => i !== index)
    }));
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
              value={state.title}
              onChange={(e) => setState(prev => ({ ...prev, title: e.target.value }))}
              required
              fullWidth
              placeholder="Nom de l'élection"
            />

            <TextField
              label="Description (optionnelle)"
              value={state.desc}
              onChange={(e) => setState(prev => ({ ...prev, desc: e.target.value }))}
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
                    <Box display="flex" justifyContent="space-between" alignItems="flex-start" mb={2}>
                      <Chip 
                        label={`Question ${questionIndex + 1}`} 
                        size="small" 
                        color="primary" 
                        variant="outlined"
                      />
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
                      <TextField
                        label="Nom de la question (optionnel)"
                        value={question.question}
                        onChange={(e) => updateQuestion(questionIndex, 'question', e.target.value)}
                        fullWidth
                        placeholder="ex: Qui voulez-vous élire comme président ?"
                      />

                      <Box>
                        <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                          <Typography variant="subtitle2" color="text.secondary">
                            Choix (au moins 2)
                          </Typography>
                          <Button
                            startIcon={<AddIcon />}
                            onClick={() => addAnswer(questionIndex)}
                            size="small"
                            variant="text"
                          >
                            Ajouter un choix
                          </Button>
                        </Box>

                        <Stack spacing={1}>
                          {question.answers.map((answer, answerIndex) => (
                            <Box key={answerIndex} display="flex" gap={1} alignItems="center">
                              <TextField
                                value={answer}
                                onChange={(e) => updateAnswer(questionIndex, answerIndex, e.target.value)}
                                fullWidth
                                size="small"
                                placeholder={`Choix ${answerIndex + 1}`}
                              />
                              {question.answers.length > 2 && (
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
                <Typography>Avancé</Typography>
              </AccordionSummary>
              <AccordionDetails>
                <Stack spacing={3}>
                  <DateTimePicker
                    label="Date de début (optionnelle)"
                    value={state.startDate}
                    onChange={(newValue) => setState(prev => ({ ...prev, startDate: newValue || undefined }))}
                    slotProps={{
                      textField: {
                        fullWidth: true
                      }
                    }}
                  />

                  <DateTimePicker
                    label="Date de fin (optionnelle)"
                    value={state.endDate}
                    onChange={(newValue) => setState(prev => ({ ...prev, endDate: newValue || undefined }))}
                    slotProps={{
                      textField: {
                        fullWidth: true
                      }
                    }}
                  />

                  <FormControl component="fieldset">
                    <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                      <FormLabel component="legend">Type d'invitation</FormLabel>
                      <IconButton 
                        onClick={() => openHelp(
                          "Type d'invitation", 
                          "• Par lien : Génère un lien unique à partager avec les électeurs. Simple et pratique pour les élections ouvertes.\n\n• Par email : Envoie automatiquement les invitations par email à une liste de destinataires. Recommandé pour les élections fermées avec liste d'électeurs définie."
                        )}
                        sx={{ 
                          color: 'primary.main',
                          '&:hover': { backgroundColor: 'primary.light', color: 'white' }
                        }}
                      >
                        <HelpOutlineIcon />
                      </IconButton>
                    </Box>
                    <RadioGroup
                      value={state.invitationMethod}
                      onChange={(e) => setState(prev => ({ ...prev, invitationMethod: e.target.value as InvitationMethod }))}
                      row
                    >
                      <FormControlLabel
                        value="lien"
                        control={<Radio />}
                        label="Par lien"
                      />
                      <FormControlLabel
                        value="email"
                        control={<Radio />}
                        label="Par email"
                      />
                    </RadioGroup>

                    {/* Email list section - only show when email is selected */}
                    {state.invitationMethod === 'email' && (
                      <Box sx={{ mt: 2 }}>
                        <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                          Liste des électeurs ({state.emails.length} email{state.emails.length !== 1 ? 's' : ''})
                        </Typography>
                        
                        <TextField
                          placeholder="Collez vos emails ici (un par ligne ou séparés par des virgules, espaces, etc.)&#10;Exemple:&#10;user1@example.com&#10;user2@example.com, user3@example.com"
                          value={emailInput}
                          onChange={(e) => handleEmailTextChange(e.target.value)}
                          multiline
                          rows={4}
                          fullWidth
                          sx={{ mb: 2 }}
                        />
                        
                        <Box display="flex" gap={1} mb={2}>
                          <Button
                            onClick={parseAndAddEmails}
                            variant="contained"
                            size="small"
                            disabled={!emailInput.trim()}
                            fullWidth
                          >
                            Extraire et ajouter les emails
                          </Button>
                          <Button
                            onClick={() => setEmailInput('')}
                            variant="outlined"
                            size="small"
                            disabled={!emailInput.trim()}
                          >
                            Vider
                          </Button>
                        </Box>

                        {state.emails.length > 0 && (
                          <Box sx={{ maxHeight: '200px', overflowY: 'auto' }}>
                            <Stack spacing={1}>
                              {state.emails.map((email, index) => (
                                <Chip
                                  key={index}
                                  label={email}
                                  onDelete={() => removeEmail(index)}
                                  variant="outlined"
                                  size="small"
                                  sx={{ justifyContent: 'space-between' }}
                                />
                              ))}
                            </Stack>
                          </Box>
                        )}

                        {state.emails.length === 0 && (
                          <Typography variant="body2" color="text.secondary" sx={{ fontStyle: 'italic' }}>
                            Aucun email ajouté. Les invitations seront envoyées aux adresses de cette liste.
                          </Typography>
                        )}
                      </Box>
                    )}
                  </FormControl>

                  <FormControl component="fieldset">
                    <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                      <FormLabel component="legend">Type de scrutin</FormLabel>
                      <IconButton 
                        onClick={() => openHelp(
                          "Type de scrutin", 
                          "• Scrutin uninominal : Les électeurs choisissent une seule option parmi celles proposées. Le candidat avec le plus de voix l'emporte.\n\n• Jugement majoritaire : Les électeurs évaluent chaque option sur une échelle (ex: Très bien, Bien, Assez bien, Passable, Insuffisant, À rejeter). L'option avec la meilleure mention majoritaire gagne."
                        )}
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
                  color="text.secondary" 
                  sx={{ mt: 1, display: 'block', textAlign: 'center' }}
                >
                  {!state.title.trim() && "Le titre est obligatoire. "}
                  {state.questions.some(q => q.answers.filter(a => a.trim() !== '').length < 2) && 
                    "Chaque question doit avoir au moins 2 choix non vides."
                  }
                </Typography>
              )}
            </Box>
          </Stack>
        </Box>
      </Paper>

      {/* Help Dialog */}
      <Dialog 
        open={helpDialog.open} 
        onClose={closeHelp}
        maxWidth="sm"
        fullWidth
      >
        <DialogTitle>
          <Box display="flex" justifyContent="space-between" alignItems="center">
            <Typography variant="h6">{helpDialog.title}</Typography>
            <IconButton onClick={closeHelp} size="small">
              <CloseIcon />
            </IconButton>
          </Box>
        </DialogTitle>
        <DialogContent>
          <Typography variant="body1" sx={{ whiteSpace: 'pre-line' }}>
            {helpDialog.content}
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={closeHelp} variant="contained">
            Compris
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
}

export default App;
