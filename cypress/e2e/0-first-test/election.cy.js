describe('election', () => {
  beforeEach(() => {
    cy.clearAllLocalStorage()
    cy.visit('http://localhost:19006/')
    cy.intercept("https://api.scrutin.app/v0/elections/")

    cy.get('[data-testid="login-username"]').type(`testaccount`, {delay: 0})
    cy.get('[data-testid="login-password"]').type(`testaccount{enter}`, {delay: 0})
    cy.contains('Hello testaccount')
  })

  it('can create an election', () => {
    cy.contains('Creer une nouvelle election').click()
    cy.get('[data-testid="election-name"]').type(`Testing election from cypress`, {delay: 0})

    cy.get('[data-testid="choice-list"]').contains('Nouveau').click()
    cy.get('[data-testid="choice-name"]').type('First choice', {delay: 0})
    cy.contains('Ajouter').click()
    cy.get('[data-testid="choice-list"]').contains('Nouveau').click()
    cy.get('[data-testid="choice-name"]').type('Second choice', {delay: 0})
    cy.contains('Ajouter').click()

    cy.get('[data-testid="voter-list"]').contains('Nouveau').click()
    cy.get('[data-testid="voter-email"]').type('someone@a-non-existing-website.wtf', {delay: 0})
    cy.contains('Ajouter').click()

    cy.contains("Create election").click()
    cy.contains("Election > Testing election from cypress")
  })
})
