import React from 'react';
import {
  Paper,
  Typography,
  Box,
  Stepper,
  Step,
  StepLabel,
  StepConnector,
  styled
} from '@mui/material';
import {
  CheckCircleOutlined
} from '@mui/icons-material';

export interface StepInfo {
  id: string;
  label: string;
  icon: React.ReactNode;
  completed: boolean;
  hasError?: boolean;
}

interface StepNavigationProps {
  steps: StepInfo[];
  currentStep: string;
  onStepClick: (stepId: string) => void;
}

const CustomStepConnector = styled(StepConnector)(({ theme }) => ({
  '&.Mui-active': {
    '& .MuiStepConnector-line': {
      borderColor: theme.palette.primary.main,
    },
  },
  '&.Mui-completed': {
    '& .MuiStepConnector-line': {
      borderColor: theme.palette.success.main,
    },
  },
}));

const StepNavigation: React.FC<StepNavigationProps> = ({
  steps,
  currentStep,
  onStepClick
}) => {
  const currentStepIndex = steps.findIndex(step => step.id === currentStep);

  return (
    <Paper 
      elevation={2} 
      sx={{ 
        height: 'fit-content',
        minHeight: '400px',
        position: 'sticky',
        top: 20
      }}
    >
      <Box sx={{ p: 3 }}>
        <Typography variant="h6" sx={{ mb: 3, fontWeight: 600 }}>
          Création d'élection
        </Typography>
        
        <Stepper 
          activeStep={currentStepIndex} 
          orientation="vertical"
          connector={<CustomStepConnector />}
        >
          {steps.map((step, index) => (
            <Step key={step.id} completed={step.completed}>
              <StepLabel
                error={step.hasError}
                StepIconComponent={({ completed, active, error }) => (
                  <Box
                    sx={{
                      width: 40,
                      height: 40,
                      borderRadius: '50%',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      bgcolor: error 
                        ? 'error.main' 
                        : completed 
                          ? 'success.main' 
                          : active 
                            ? 'primary.main' 
                            : 'grey.300',
                      color: error || completed || active ? 'white' : 'grey.600',
                      cursor: 'pointer',
                      transition: 'all 0.2s ease-in-out',
                      '&:hover': {
                        transform: 'scale(1.1)',
                        bgcolor: error 
                          ? 'error.dark' 
                          : completed 
                            ? 'success.dark' 
                            : active 
                              ? 'primary.dark' 
                              : 'grey.400'
                      }
                    }}
                    onClick={() => onStepClick(step.id)}
                  >
                    {completed ? (
                      <CheckCircleOutlined fontSize="small" />
                    ) : (
                      step.icon
                    )}
                  </Box>
                )}
                onClick={() => onStepClick(step.id)}
                sx={{ cursor: 'pointer' }}
              >
                <Typography
                  variant="body2"
                  sx={{
                    fontWeight: step.id === currentStep ? 600 : 400,
                    color: step.hasError 
                      ? 'error.main' 
                      : step.id === currentStep 
                        ? 'primary.main' 
                        : 'text.primary',
                    cursor: 'pointer'
                  }}
                  onClick={() => onStepClick(step.id)}
                >
                  {step.label}
                </Typography>
              </StepLabel>
            </Step>
          ))}
        </Stepper>
      </Box>
    </Paper>
  );
};

export default StepNavigation;