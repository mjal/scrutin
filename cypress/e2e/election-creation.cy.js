describe('Election Creation E2E Test', () => {
  beforeEach(() => {
    // Start fresh for each test
    cy.clearLocalStorage()
    cy.clearCookies()
    
    // Mock authentication for testing
    // In a real scenario, you'd need to handle login properly
    cy.window().then((win) => {
      win.localStorage.setItem('logged', 'true')
      win.localStorage.setItem('email', 'test@example.com')
      win.localStorage.setItem('auth_code', '179195')
    })
    
    // Visit the admin app
    cy.visit('/')
  })

  it('should create an election', () => {
    // Should redirect to elections page when logged in
    cy.url().should('include', '/elections')
    
    cy.contains('Créer une nouvelle élection').click()
    cy.url().should('include', '/elections/new')
    
    cy.contains('Informations de base').should('be.visible')
    cy.get('input[placeholder*="Élection des représentants"]').type('Test Election - Cypress', { delay: 0 })
    cy.get('textarea[placeholder*="Décrivez brièvement"]').type('This is a test election created by Cypress automation', { delay: 0 })
    cy.contains('Suivant').click()
    
    cy.contains('Questions').should('be.visible')
    cy.get('input').first().should('be.visible')
    cy.get('input').eq(0).clear().type('Option A - First Choice', { delay: 0 })
    cy.get('input').eq(1).clear().type('Option B - Second Choice', { delay: 0 })
    //// Add a third choice
    //cy.contains('Ajouter').click()
    //cy.get('input').last().type('Option C - Third Choice')
    cy.contains('Suivant').click()
    
    cy.contains('Paramètres').should('be.visible')
    cy.contains('Suivant').click()
    
    cy.contains('Vérification').should('be.visible')
    cy.contains('Test Election - Cypress').should('be.visible')
    cy.contains('This is a test election created by Cypress automation').should('be.visible')
    cy.contains('Option A - First Choice').should('be.visible')
    cy.contains('Option B - Second Choice').should('be.visible')
    //cy.contains('Option C - Third Choice').should('be.visible')

    cy.get('[data-testid="create-election-button"]').click()
    
    // Should redirect to the created election page
    cy.url().should('include', '/elections/')
    cy.url().should('not.include', '/new')
    cy.get('body').should('contain.text', 'Test Election - Cypress')

    cy.visit('/elections')
    cy.get('body').should('be.visible')
    // TODO Show election title
  })
})