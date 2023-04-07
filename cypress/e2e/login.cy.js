/*
describe('login', () => {
  beforeEach(() => {
    cy.clearAllLocalStorage()
    cy.visit('http://localhost:19006/')
    cy.intercept("https://api.scrutin.app/v0/elections/")
  })

  it('displays a login form', () => {
    cy.contains('Please login')
  })

  it('can login with enter', () => {
    cy.get('[data-testid="login-username"]').type(`testaccount`)
    cy.get('[data-testid="login-password"]').type(`testaccount{enter}`)
    cy.contains('Creer une nouvelle election')
  })

  it('can login with button press', () => {
    cy.get('[data-testid="login-username"]').type(`testaccount`)
    cy.get('[data-testid="login-password"]').type(`testaccount`)
    cy.contains('Login').click()
    cy.contains('Creer une nouvelle election')
  })
})
*/
