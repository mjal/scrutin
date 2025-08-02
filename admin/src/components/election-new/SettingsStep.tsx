import React, { useState } from 'react';
import {
  Box,
  TextField,
  Typography,
  Stack,
  Paper,
  FormControl,
  FormLabel,
  RadioGroup,
  FormControlLabel,
  Radio,
  IconButton
} from '@mui/material';
import {
  HelpOutline as HelpOutlineIcon
} from '@mui/icons-material';
import { DateTimePicker } from '@mui/x-date-pickers/DateTimePicker';
import dayjs from 'dayjs';
import { Election } from 'sirona';
import HelpDialog from '../HelpDialog';

interface SettingsStepProps {
  state: Election.t & { access: string; votingMethod: string };
  emailInput: string;
  onChange: (updates: Partial<Election.t & { access: string; votingMethod: string }>) => void;
  onEmailChange: (email: string) => void;
}

const SettingsStep: React.FC<SettingsStepProps> = ({ 
  state, 
  emailInput, 
  onChange,
  onEmailChange 
}) => {
  const [helpDialog, setHelpDialog] = useState<{
    open: boolean;
    title: string;
    content: string;
  }>({
    open: false,
    title: '',
    content: ''
  });

  return (
    <>
      <Paper elevation={1} sx={{ p: 4 }}>
        <Typography variant="h5" sx={{ mb: 3, fontWeight: 600 }}>
          Paramètres de l'élection
        </Typography>
        
        <Typography variant="body2" color="text.secondary" sx={{ mb: 4 }}>
          Configurez les dates, l'accès et le type de scrutin de votre élection.
        </Typography>

        <Stack spacing={4}>
          {/* Dates Section */}
          <Box>
            <Typography variant="h6" sx={{ mb: 2, fontWeight: 500 }}>
              Dates de l'élection
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
              Optionnel : définissez une période pendant laquelle l'élection sera ouverte.
            </Typography>
            
            <Stack spacing={3}>
              <DateTimePicker
                label="Date de début (optionnelle)"
                value={state.startDate ? dayjs(state.startDate) : null}
                onChange={(newValue) =>
                  onChange({
                    startDate: newValue ? newValue.toDate() : undefined
                  })
                }
                slotProps={{
                  textField: {
                    fullWidth: true,
                    helperText: "L'élection ne sera accessible qu'à partir de cette date"
                  }
                }}
              />

              <DateTimePicker
                label="Date de fin (optionnelle)"
                value={state.endDate ? dayjs(state.endDate) : null}
                onChange={(newValue) =>
                  onChange({
                    endDate: newValue ? newValue.toDate() : undefined
                  })
                }
                slotProps={{
                  textField: {
                    fullWidth: true,
                    helperText: "L'élection sera automatiquement fermée à cette date"
                  }
                }}
              />
            </Stack>
          </Box>

          {/* Access Type Section */}
          <Box>
            <FormControl component="fieldset" fullWidth>
              <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                <FormLabel component="legend">
                  <Typography variant="h6" sx={{ fontWeight: 500 }}>
                    Type d'invitation
                  </Typography>
                </FormLabel>
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
              
              <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                Choisissez comment les électeurs accèderont à l'élection.
              </Typography>
              
              <RadioGroup
                value={state.access}
                onChange={(e) => onChange({ access: e.target.value as 'open' | 'closed' })}
                row
              >
                <FormControlLabel
                  value="open"
                  control={<Radio />}
                  label="Par lien public"
                />
                <FormControlLabel
                  value="closed"
                  control={<Radio />}
                  label="Par email privé"
                />
              </RadioGroup>

              {/* Email list section - only show when email is selected */}
              {state.access === 'closed' && (
                <Box sx={{ mt: 3 }}>
                  {emailInput.split(/\r?\n/).length >= 2 && (
                    <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                      Liste des électeurs ({emailInput.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g)?.length || 0} email{(emailInput.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g)?.length || 0) !== 1 ? 's' : ''})
                    </Typography>
                  )}
                  
                  <TextField
                    placeholder="Collez vos emails ici (un par ligne)&#10;Exemple:&#10;user1@example.com&#10;user2@example.com"
                    value={emailInput}
                    onChange={(e) => onEmailChange(e.target.value)}
                    multiline
                    rows={6}
                    fullWidth
                    helperText="Un email par ligne. Les invitations seront envoyées automatiquement."
                  />
                </Box>
              )}
            </FormControl>
          </Box>

          {/* Voting Method Section */}
          <Box>
            <FormControl component="fieldset" fullWidth>
              <Box display="flex" justifyContent="space-between" alignItems="center" mb={1}>
                <FormLabel component="legend">
                  <Typography variant="h6" sx={{ fontWeight: 500 }}>
                    Type de scrutin
                  </Typography>
                </FormLabel>
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
              
              <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                Sélectionnez le mode de vote pour cette élection.
              </Typography>
              
              <RadioGroup
                value={state.votingMethod}
                onChange={(e) => onChange({ votingMethod: e.target.value as 'uninominal' | 'majorityJudgement' })}
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
          </Box>
        </Stack>
      </Paper>

      {/* Help Dialog */}
      <HelpDialog
        open={helpDialog.open}
        title={helpDialog.title}
        content={helpDialog.content}
        onClose={() => setHelpDialog(prev => ({ ...prev, open: false }))}
      />
    </>
  );
};

export default SettingsStep;