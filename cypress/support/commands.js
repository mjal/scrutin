// Custom commands for Scrutin election testing

// Command to start both admin app and server
Cypress.Commands.add('startServices', () => {
  // This assumes services are already running
  // In a real setup, you might want to programmatically start services
  cy.visit('/')
})

// Command to create a basic election
Cypress.Commands.add('createElection', (electionData = {}) => {
  const defaultData = {
    title: 'Test Election',
    description: 'A test election created by Cypress',
    questions: [
      {
        title: 'Choose your preferred option',
        choices: ['Option A', 'Option B', 'Option C']
      }
    ],
    ...electionData
  }

  // Navigate to election creation
  cy.get('[data-testid="create-election-button"]').should('be.visible').click()
  
  // Fill basic info
  cy.get('[data-testid="election-title"]').type(defaultData.title)
  cy.get('[data-testid="election-description"]').type(defaultData.description)
  
  // Continue to next step
  cy.get('[data-testid="next-step-button"]').click()
  
  // Add questions and choices
  defaultData.questions.forEach((question, qIndex) => {
    if (qIndex > 0) {
      cy.get('[data-testid="add-question-button"]').click()
    }
    
    cy.get(`[data-testid="question-title-${qIndex}"]`).type(question.title)
    
    question.choices.forEach((choice, cIndex) => {
      if (cIndex > 1) { // First 2 choices are usually pre-added
        cy.get(`[data-testid="add-choice-button-${qIndex}"]`).click()
      }
      cy.get(`[data-testid="choice-${qIndex}-${cIndex}"]`).clear().type(choice)
    })
  })
  
  // Continue through remaining steps
  cy.get('[data-testid="next-step-button"]').click() // Questions -> Settings
  cy.get('[data-testid="next-step-button"]').click() // Settings -> Review
  
  // Create the election
  cy.get('[data-testid="create-election-submit"]').click()
  
  // Wait for creation to complete
  cy.url().should('include', '/election/')
  cy.get('[data-testid="election-created-success"]').should('be.visible')
})

// Command to wait for server to be ready
Cypress.Commands.add('waitForServer', () => {
  cy.request({
    url: `${Cypress.env('serverUrl')}/health`,
    failOnStatusCode: false,
    timeout: 30000
  }).then((response) => {
    if (response.status !== 200) {
      cy.wait(2000)
      cy.waitForServer()
    }
  })
})

// Command to clean up test data
Cypress.Commands.add('cleanupTestData', () => {
  // This would typically call an API endpoint to clean test data
  // For now, we'll just clear local storage
  cy.clearLocalStorage()
  cy.clearCookies()
})