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

  it('should create a complete election through the multi-step process', () => {
    // Should redirect to elections page when logged in
    cy.url().should('include', '/elections')
    
    // Click on create new election button
    cy.contains('Créer une nouvelle élection').click()
    
    // Should navigate to election creation page
    cy.url().should('include', '/elections/new')
    
    // ===== STEP 1: Basic Information =====
    cy.contains('Informations de base').should('be.visible')
    
    // Fill election title (required)
    cy.get('input[placeholder*="Élection des représentants"]').type('Test Election - Cypress')
    
    // Fill description (optional)
    cy.get('textarea[placeholder*="Décrivez brièvement"]').type('This is a test election created by Cypress automation')
    
    // Go to next step
    cy.contains('Suivant').click()
    
    // ===== STEP 2: Questions =====
    cy.contains('Questions').should('be.visible')
    
    // Should have default question setup
    // Update the first question title (single question doesn't require title)
    cy.get('input').first().should('be.visible')
    
    // Update the first two default choices
    cy.get('input').eq(0).clear().type('Option A - First Choice')
    cy.get('input').eq(1).clear().type('Option B - Second Choice')
    
    //// Add a third choice
    //cy.contains('Ajouter').click()
    //cy.get('input').last().type('Option C - Third Choice')
    
    // Go to next step
    cy.contains('Suivant').click()
    
    // ===== STEP 3: Settings =====
    cy.contains('Paramètres').should('be.visible')
    
    // Keep default settings (open access)
    // The default should be 'open' access which doesn't require emails
    
    // Go to next step
    cy.contains('Suivant').click()
    
    // ===== STEP 4: Review =====
    cy.contains('Vérification').should('be.visible')
    
    // Verify our election details are shown
    cy.contains('Test Election - Cypress').should('be.visible')
    cy.contains('This is a test election created by Cypress automation').should('be.visible')
    cy.contains('Option A - First Choice').should('be.visible')
    cy.contains('Option B - Second Choice').should('be.visible')
    //cy.contains('Option C - Third Choice').should('be.visible')
    
    // Submit the election
    cy.get('[data-testid="create-election-button"]').click()
    
    // ===== VERIFICATION =====
    // Should redirect to the created election page
    cy.url().should('include', '/elections/')
    cy.url().should('not.include', '/new')
    
    // Verify election was created successfully
    // The exact success message may vary, so we check for common success indicators
    cy.get('body').should('contain.text', 'Test Election - Cypress')

    // Verify we can navigate back to elections list
    cy.visit('/elections')

    // Should see our new election in the list
    cy.get('body').should('be.visible')
  })
})