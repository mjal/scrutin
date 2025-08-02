// Additional commands specific to election creation testing

// Command to mock authentication
Cypress.Commands.add('mockAuth', (email = 'test@example.com', authCode = 'test-auth-code') => {
  cy.window().then((win) => {
    win.localStorage.setItem('logged', 'true')
    win.localStorage.setItem('email', email)
    win.localStorage.setItem('auth_code', authCode)
  })
})

// Command to fill basic election info
Cypress.Commands.add('fillBasicElectionInfo', (title, description = '') => {
  cy.get('input[placeholder*="Élection des représentants"], input[placeholder*="election"], [data-testid="election-title"], input:first').first().clear().type(title)
  
  if (description) {
    cy.get('textarea[placeholder*="Décrivez"], textarea:first, [data-testid="election-description"]').first().clear().type(description)
  }
})

// Command to add election choices
Cypress.Commands.add('fillElectionChoices', (choices) => {
  choices.forEach((choice, index) => {
    if (index < 2) {
      // Clear and fill existing inputs
      cy.get('input').eq(index).clear().type(choice)
    } else {
      // Add new choice if more than 2
      cy.contains('Ajouter', { matchCase: false }).click()
      cy.get('input').last().type(choice)
    }
  })
})

// Command to navigate through election steps
Cypress.Commands.add('navigateElectionSteps', (targetStep) => {
  const steps = ['basic', 'questions', 'settings', 'review']
  const targetIndex = steps.indexOf(targetStep)
  
  for (let i = 0; i < targetIndex; i++) {
    cy.contains('Suivant').click()
  }
})

// Command to create a complete election
Cypress.Commands.add('createCompleteElection', (electionData) => {
  // Navigate to creation page
  cy.visit('/elections/new')
  
  // Fill basic info
  cy.fillBasicElectionInfo(electionData.title, electionData.description)
  cy.contains('Suivant').click()
  
  // Fill questions
  if (electionData.questions && electionData.questions[0] && electionData.questions[0].choices) {
    cy.fillElectionChoices(electionData.questions[0].choices)
  }
  cy.contains('Suivant').click()
  
  // Skip settings (use defaults)
  cy.contains('Suivant').click()
  
  // Submit
  cy.contains('Créer l\'élection', { timeout: 10000 }).click()
})

// Command to verify election creation success
Cypress.Commands.add('verifyElectionCreated', (electionTitle) => {
  cy.url().should('include', '/elections/')
  cy.url().should('not.include', '/new')
  cy.get('body').should('contain.text', electionTitle)
})

// Command to check if element exists without failing
Cypress.Commands.add('elementExists', (selector) => {
  return cy.get('body').then($body => {
    return $body.find(selector).length > 0
  })
})