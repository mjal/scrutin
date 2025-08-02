import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Container,
  Box,
  Button
} from '@mui/material';
import {
  InfoOutlined,
  QuizOutlined,
  SettingsOutlined,
  PreviewOutlined,
  ArrowBack,
  ArrowForward
} from '@mui/icons-material';
import { Question, Setup, Election, Trustee, Point, Zq } from 'sirona';
import { config } from '../config';
import Header from '../components/Header';

// Step components
import StepNavigation, { StepInfo } from '../components/election-new/StepNavigation';
import BasicInfoStep from '../components/election-new/BasicInfoStep';
import QuestionsStep from '../components/election-new/QuestionsStep';
import SettingsStep from '../components/election-new/SettingsStep';
import ReviewStep from '../components/election-new/ReviewStep';

type StepId = 'basic' | 'questions' | 'settings' | 'review';

const ElectionNewPage: React.FC = () => {
  const navigate = useNavigate();
  
  // Current step state
  const [currentStep, setCurrentStep] = useState<StepId>('basic');
  
  // Form state
  const [state, setState] = useState<Election.t & { access: string; votingMethod: string }>({
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

  // Email input state
  const [emailInput, setEmailInput] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Step validation functions
  function isStepCompleted(stepId: StepId): boolean {
    switch (stepId) {
      case 'basic':
        return state.name.trim() !== '';
      case 'questions':
        return state.questions.every(q => {
          const qh = q as Question.QuestionH.t;
          const validAnswers = qh.answers.filter(a => a.trim() !== '');
          const questionValid = state.questions.length === 1 || qh.question.trim() !== '';
          return questionValid && validAnswers.length >= 2;
        });
      case 'settings':
        return state.access === 'open' || (state.access === 'closed' && emailInput.trim() !== '');
      case 'review':
        return isFormValid();
      default:
        return false;
    }
  }

  function hasStepError(stepId: StepId): boolean {
    // Only show errors for steps that have been visited but are incomplete
    const stepOrder: StepId[] = ['basic', 'questions', 'settings', 'review'];
    const currentStepIndex = stepOrder.indexOf(currentStep);
    const stepIndex = stepOrder.indexOf(stepId);
    
    if (stepIndex >= currentStepIndex) return false;
    
    return !isStepCompleted(stepId);
  }

  // Form validation
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

    // Check that each question has at least 2 non-empty answers
    for (const question of state.questions) {
      const questionH = question as Question.QuestionH.t;
      const nonEmptyAnswers = questionH.answers.filter(answer => answer.trim() !== '');
      if (nonEmptyAnswers.length < 2) {
        return false;
      }
    }

    // Check email access requirements
    if (state.access === 'closed' && emailInput.trim() === '') {
      return false;
    }

    return true;
  };

  const getValidationErrors = (): string[] => {
    const errors: string[] = [];
    
    if (!state.name.trim()) {
      errors.push("Le titre est obligatoire");
    }

    if (state.questions.length > 1) {
      state.questions.forEach((question, index) => {
        const questionH = question as Question.QuestionH.t;
        if (!questionH.question.trim()) {
          errors.push(`Le nom de la question ${index + 1} est obligatoire`);
        }
      });
    }

    state.questions.forEach((question, index) => {
      const questionH = question as Question.QuestionH.t;
      const nonEmptyAnswers = questionH.answers.filter(answer => answer.trim() !== '');
      if (nonEmptyAnswers.length < 2) {
        const questionLabel = state.questions.length > 1 ? ` ${index + 1}` : '';
        errors.push(`La question${questionLabel} doit avoir au moins 2 options non vides`);
      }
    });

    if (state.access === 'closed' && emailInput.trim() === '') {
      errors.push("La liste d'emails est obligatoire pour l'accès par email");
    }

    return errors;
  };

  // Step definitions
  const steps: StepInfo[] = [
    {
      id: 'basic',
      label: 'Informations de base',
      icon: <InfoOutlined fontSize="small" />,
      completed: isStepCompleted('basic'),
      hasError: hasStepError('basic')
    },
    {
      id: 'questions',
      label: 'Questions',
      icon: <QuizOutlined fontSize="small" />,
      completed: isStepCompleted('questions'),
      hasError: hasStepError('questions')
    },
    {
      id: 'settings',
      label: 'Paramètres',
      icon: <SettingsOutlined fontSize="small" />,
      completed: isStepCompleted('settings'),
      hasError: hasStepError('settings')
    },
    {
      id: 'review',
      label: 'Vérification',
      icon: <PreviewOutlined fontSize="small" />,
      completed: isStepCompleted('review'),
      hasError: hasStepError('review')
    }
  ];

  // Navigation
  const canGoNext = (): boolean => {
    return isStepCompleted(currentStep);
  };

  const canGoPrevious = (): boolean => {
    const currentIndex = steps.findIndex(s => s.id === currentStep);
    return currentIndex > 0;
  };

  const goNext = () => {
    const currentIndex = steps.findIndex(s => s.id === currentStep);
    if (currentIndex < steps.length - 1) {
      setCurrentStep(steps[currentIndex + 1].id as StepId);
    }
  };

  const goPrevious = () => {
    const currentIndex = steps.findIndex(s => s.id === currentStep);
    if (currentIndex > 0) {
      setCurrentStep(steps[currentIndex - 1].id as StepId);
    }
  };

  const handleStepClick = (stepId: string) => {
    setCurrentStep(stepId as StepId);
  };

  // State update handler
  const handleStateChange = (updates: Partial<Election.t & { access: string; votingMethod: string }>) => {
    setState(prev => ({ ...prev, ...updates }));
  };

  // Form submission
  const handleSubmit = async () => {
    if (!isFormValid()) {
      return;
    }

    setIsSubmitting(true);

    try {
      const privkey = Zq.rand();
      const [, serializedTrustee] = Trustee.generateFromPriv(privkey);
      const trustee = Trustee.parse(serializedTrustee);
      const trustees = [trustee];

      console.log('Generated trustees:', trustees);

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

      const userEmail = localStorage.getItem('email');
      const authCode = localStorage.getItem('auth_code');

      const response = await fetch(`${config.server.url}/${election.uuid}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          setup: Setup.serialize(setup),
          emails,
          email: userEmail,
          auth_code: authCode
        }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      console.log('Election saved to server:', result);

      navigate(`/elections/${result.uuid}`);
    } catch (error) {
      console.error('Error creating election:', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  // Render current step
  const renderCurrentStep = () => {
    switch (currentStep) {
      case 'basic':
        return (
          <BasicInfoStep
            state={state}
            onChange={handleStateChange}
          />
        );
      case 'questions':
        return (
          <QuestionsStep
            state={state}
            onChange={handleStateChange}
          />
        );
      case 'settings':
        return (
          <SettingsStep
            state={state}
            emailInput={emailInput}
            onChange={handleStateChange}
            onEmailChange={setEmailInput}
          />
        );
      case 'review':
        return (
          <ReviewStep
            state={state}
            emailInput={emailInput}
            isValid={isFormValid()}
            validationErrors={getValidationErrors()}
          />
        );
      default:
        return null;
    }
  };

  return (
    <>
      <Header />
      <Container maxWidth="xl" sx={{ py: 4 }}>
        <Box sx={{ display: 'flex', gap: 4, flexDirection: { xs: 'column', md: 'row' } }}>
          {/* Left Navigation */}
          <Box sx={{ flexShrink: 0, width: { xs: '100%', md: '300px' } }}>
            <StepNavigation
              steps={steps}
              currentStep={currentStep}
              onStepClick={handleStepClick}
            />
          </Box>
          
          {/* Main Content */}
          <Box sx={{ flex: 1, minWidth: 0 }}>
            <Box sx={{ minHeight: '600px' }}>
              {renderCurrentStep()}
              
              {/* Navigation Buttons */}
              <Box sx={{ mt: 4, display: 'flex', justifyContent: 'space-between' }}>
                <Button
                  startIcon={<ArrowBack />}
                  onClick={goPrevious}
                  disabled={!canGoPrevious()}
                  variant="outlined"
                >
                  Précédent
                </Button>
                
                <Box>
                  {currentStep === 'review' ? (
                    <Button
                      variant="contained"
                      size="large"
                      onClick={handleSubmit}
                      disabled={!isFormValid() || isSubmitting}
                      sx={{ minWidth: 160 }}
                    >
                      {isSubmitting ? 'Création...' : 'Créer l\'élection'}
                    </Button>
                  ) : (
                    <Button
                      endIcon={<ArrowForward />}
                      onClick={goNext}
                      disabled={!canGoNext()}
                      variant="contained"
                    >
                      Suivant
                    </Button>
                  )}
                </Box>
              </Box>
            </Box>
          </Box>
        </Box>
      </Container>
    </>
  );
};

export default ElectionNewPage;