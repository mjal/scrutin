import React from 'react';
import {
  Box,
  TextField,
  Typography,
  Stack,
  Paper,
  Button,
  IconButton,
  Chip
} from '@mui/material';
import {
  Add as AddIcon,
  Delete as DeleteIcon
} from '@mui/icons-material';
import { Election, Question } from 'sirona';

interface QuestionsStepProps {
  state: Election.t;
  onChange: (updates: Partial<Election.t>) => void;
}

const QuestionsStep: React.FC<QuestionsStepProps> = ({ state, onChange }) => {
  const addQuestion = () => {
    onChange({
      questions: [
        ...state.questions,
        {
          question: '',
          answers: ['', ''],
          min: 1,
          max: 1
        }
      ]
    });
  };

  const removeQuestion = (index: number) => {
    onChange({
      questions: state.questions.filter((_, i) => i !== index)
    });
  };

  const updateQuestion = (index: number, field: keyof Question.QuestionH.t, value: any) => {
    onChange({
      questions: state.questions.map((q, i) => 
        i === index ? { ...q, [field]: value } : q
      )
    });
  };

  const addAnswer = (questionIndex: number) => {
    onChange({
      questions: state.questions.map((q, i) => {
        const qh = q as Question.QuestionH.t;
        return i === questionIndex ? { ...q, answers: [...qh.answers, ''] } : q;
      })
    });
  };

  const removeAnswer = (questionIndex: number, answerIndex: number) => {
    onChange({
      questions: state.questions.map((q, i) => {
        const qh = q as Question.QuestionH.t;
        return i === questionIndex ? { 
          ...q, 
          answers: qh.answers.filter((_, ai) => ai !== answerIndex) 
        } : q
        }
      )
    });
  };

  const updateAnswer = (questionIndex: number, answerIndex: number, value: string) => {
    onChange({
      questions: state.questions.map((q, i) => {
        const qh = q as Question.QuestionH.t;
        return i === questionIndex ? { 
          ...q, 
          answers: qh.answers.map((a, ai) => ai === answerIndex ? value : a)
        } : q
      })
    });
  };

  return (
    <Paper elevation={1} sx={{ p: 4 }}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Box>
          <Typography variant="h5" sx={{ fontWeight: 600 }}>
            Questions de l'élection
          </Typography>
          <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
            Définissez les questions et les options de vote.
          </Typography>
        </Box>
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
            elevation={0} 
            sx={{ 
              p: 3, 
              border: '1px solid',
              borderColor: 'divider',
              borderRadius: 2,
              bgcolor: 'grey.50'
            }}
          >
            <Box display="flex" justifyContent="space-between" alignItems="flex-start" mb={2}>
              {state.questions.length > 1 && (
                <Chip
                  label={`Question ${questionIndex + 1}`} 
                  size="small" 
                  color="primary" 
                  variant="outlined"
                />
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

            <Stack spacing={3}>
              {state.questions.length > 1 && (
                <TextField
                  label="Nom de la question"
                  value={(question as Question.QuestionH.t).question}
                  onChange={(e) => updateQuestion(questionIndex, 'question', e.target.value)}
                  required
                  fullWidth
                  placeholder="ex: Qui voulez-vous élire comme président ?"
                />
              )}

              <Box>
                <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                  <Typography variant="subtitle1" fontWeight={500}>
                    Options de vote
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

                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                  Ajoutez au moins 2 options de vote. Les électeurs pourront choisir parmi ces options.
                </Typography>

                <Stack spacing={2}>
                  {
                  (question as Question.QuestionH.t).answers.map((answer, answerIndex) => (
                    <Box key={answerIndex} display="flex" gap={1} alignItems="center">
                      <TextField
                        value={answer}
                        onChange={(e) => updateAnswer(questionIndex, answerIndex, e.target.value)}
                        fullWidth
                        placeholder={`Option ${answerIndex + 1}`}
                        variant="outlined"
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
    </Paper>
  );
};

export default QuestionsStep;