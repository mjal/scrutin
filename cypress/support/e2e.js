// Import commands.js using ES2015 syntax:
import './commands'
import './election-commands'

// Alternatively you can use CommonJS syntax:
// require('./commands')
// require('./election-commands')

// Prevent Cypress from failing on uncaught exceptions
Cypress.on('uncaught:exception', (err, runnable) => {
  // returning false here prevents Cypress from failing the test
  if (err.message.includes('ResizeObserver loop limit exceeded')) {
    return false
  }
  return true
})

// Custom commands for election testing
beforeEach(() => {
  // Clear any previous state
  cy.clearLocalStorage()
  cy.clearCookies()
})