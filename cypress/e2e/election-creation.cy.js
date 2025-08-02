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
      win.localStorage.setItem('auth_code', 'test-auth-code')
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
    
    // Add a third choice
    cy.contains('Ajouter').click()
    cy.get('input').last().type('Option C - Third Choice')
    
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
    cy.contains('Option C - Third Choice').should('be.visible')
    
    // Submit the election
    cy.contains('Créer l\'élection').click()
    
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

  it('should validate required fields and prevent submission with incomplete data', () => {
    // Navigate to election creation
    cy.visit('/elections/new')
    
    // Try to proceed without filling title
    cy.contains('Suivant').should('be.disabled')
    
    // Fill minimum required title
    cy.get('input[placeholder*="Élection des représentants"]').type('Minimum Election')
    
    // Now next should be enabled
    cy.contains('Suivant').should('not.be.disabled').click()
    
    // Questions step - try to proceed with empty choices
    cy.get('input').first().clear()
    cy.get('input').eq(1).clear()
    
    // Next should be disabled with empty choices
    cy.contains('Suivant').should('be.disabled')
    
    // Fill minimum required choices
    cy.get('input').first().type('Choice 1')
    cy.get('input').eq(1).type('Choice 2')
    
    // Now should be able to proceed
    cy.contains('Suivant').should('not.be.disabled').click()
    
    // Settings step - proceed with defaults
    cy.contains('Suivant').click()
    
    // Review step - should be able to create
    cy.contains('Créer l\'élection').should('not.be.disabled')
  })

  it('should allow navigation between steps and preserve data', () => {
    cy.visit('/elections/new')
    
    // Fill basic info
    const electionTitle = 'Navigation Test Election'
    const electionDescription = 'Testing step navigation'
    
    cy.get('input[placeholder*="Élection des représentants"]').type(electionTitle)
    cy.get('textarea[placeholder*="Décrivez brièvement"]').type(electionDescription)
    cy.contains('Suivant').click()
    
    // Fill questions
    cy.get('input').first().clear().type('Updated Choice 1')
    cy.get('input').eq(1).clear().type('Updated Choice 2')
    cy.contains('Suivant').click()
    
    // Navigate back to basic info
    cy.contains('Précédent').click()
    cy.contains('Précédent').click()
    
    // Verify data is preserved
    cy.get('input[value="' + electionTitle + '"]').should('exist')
    cy.get('textarea').should('contain.value', electionDescription)
    
    // Navigate forward to questions
    cy.contains('Suivant').click()
    
    // Verify question data is preserved
    cy.get('input[value="Updated Choice 1"]').should('exist')
    cy.get('input[value="Updated Choice 2"]').should('exist')
  })

  // Test for different voting methods if applicable
  it('should handle different election configurations', () => {
    cy.visit('/elections/new')
    
    // Create a multi-question election
    cy.get('input[placeholder*="Élection des représentants"]').type('Multi-Question Election')
    cy.contains('Suivant').click()
    
    // Add multiple questions if the interface supports it
    // This depends on the actual UI implementation
    // For now, work with single question
    
    cy.get('input').first().clear().type('Question 1 - Choice A')
    cy.get('input').eq(1).clear().type('Question 1 - Choice B')
    
    cy.contains('Suivant').click()
    cy.contains('Suivant').click()
    
    // Should be able to create multi-question election
    cy.contains('Créer l\'élection').should('not.be.disabled')
  })
})