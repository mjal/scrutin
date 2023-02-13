describe('app', () => {
  beforeEach(() => {
    cy.visit('http://localhost:19006/')
  })

  //it('displays a login form', () => {
  //  cy.contains('Please login')
  //})

  it('can login', () => {
    cy.get('[data-testid="login-username"]').type(`testaccount`)
    cy.get('[data-testid="login-password"]').type(`testaccount{enter}`)
    cy.contains('Hello testaccount')
  })
})
