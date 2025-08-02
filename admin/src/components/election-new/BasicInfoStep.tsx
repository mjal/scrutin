import React from 'react';
import {
  TextField,
  Typography,
  Stack,
  Paper
} from '@mui/material';
import { Election } from 'sirona';

interface BasicInfoStepProps {
  state: Election.t;
  onChange: (updates: Partial<Election.t>) => void;
}

const BasicInfoStep: React.FC<BasicInfoStepProps> = ({ state, onChange }) => {
  return (
    <Paper elevation={1} sx={{ p: 4 }}>
      <Typography variant="h5" sx={{ mb: 3, fontWeight: 600 }}>
        Informations de base
      </Typography>
      
      <Typography variant="body2" color="text.secondary" sx={{ mb: 4 }}>
        Commencez par définir le titre et la description de votre élection.
      </Typography>

      <Stack spacing={3}>
        <TextField
          label="Titre de l'élection"
          value={state.name}
          onChange={(e) => onChange({ name: e.target.value })}
          required
          fullWidth
          placeholder="ex: Élection des représentants étudiants"
          helperText="Le titre apparaîtra en haut de chaque bulletin de vote"
        />

        <TextField
          label="Description (optionnelle)"
          value={state.description}
          onChange={(e) => onChange({ description: e.target.value })}
          multiline
          rows={4}
          fullWidth
          placeholder="Décrivez brièvement l'objectif et le contexte de cette élection..."
          helperText="Cette description aidera les électeurs à comprendre les enjeux de l'élection"
        />
      </Stack>
    </Paper>
  );
};

export default BasicInfoStep;