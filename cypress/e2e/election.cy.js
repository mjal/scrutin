describe('election', () => {
  beforeEach(() => {
    //cy.clearAllLocalStorage()
    cy.visit('http://localhost:19000/')
    cy.intercept("https://scrutin-node.fly.dev/transactions")
    //cy.intercept("https://api.scrutin.app/v0/elections/")
    //cy.get('[data-testid="login-username"]').type(`testaccount`, {delay: 0})
    //cy.get('[data-testid="login-password"]').type(`testaccount{enter}`, {delay: 0})
    //cy.contains('Creer une nouvelle election')
  })

  it('can create an election', () => {
    cy.contains('Create a new election').click()
    cy.get('[data-testid="election-name"]').type(`Testing election from cypress`, {delay: 0})

    cy.get('[data-testid="choice-list"]').contains('Add').click()
    cy.get('[data-testid="choice-name"]').type('First choice', {delay: 0})
    cy.get('[data-testid="choice-modal"]').contains('Add').click()
    cy.get('[data-testid="choice-list"]').contains('Add').click()
    cy.get('[data-testid="choice-name"]').type('Second choice', {delay: 0})
    cy.get('[data-testid="choice-modal"]').contains('Add').click()

    //cy.get('[data-testid="voter-list"]').contains('Ajouter').click()
    //cy.get('[data-testid="voter-email"]').type('someone@a-non-existing-website.wtf', {delay: 0})
    //cy.get('[data-testid="voter-modal"]').contains('Ajouter').click()

    cy.contains("Create").click()
    cy.contains("Testing election from cypress")
  })
})
