import { Given, When, Then } from "@badeball/cypress-cucumber-preprocessor";

const baseUrl = 'http://localhost:19006/'

When("I go to new election", () => {
  cy.visit(baseUrl)
  cy.contains('Create an election').click()
})

When("I add a title", () => {
  cy.get('[data-testid="election-title"]').type(`Testing election from cypress`, {delay: 0})
})

When("I add choices", () => {
  let choices = [
    "First choice",
    "Second choice",
  ]

  cy.get('[data-testid="choice-1"]').type(choices[0], {delay: 0})
  cy.get('[data-testid="choice-2"]').type(choices[1], {delay: 0})
})

When("I click next", () => {
  cy.contains("Next").click()
})

Then("Election should be created", () => {
  cy.contains("Testing election from cypress")
})

Given("I created an election", () => {
  cy.visit('http://localhost:19006/')
  cy.contains('Create an election').click()
  cy.get('[data-testid="election-title"]').type(`Testing election from cypress`, {delay: 0})
  cy.contains("Next").click()
})

When("I create an invitation link", () => {
  cy.get('[data-testid="button-invite"]').click()
  cy.get('[data-testid="button-invite-link"]').click()
  cy.wait(1000)
  cy.get('[data-testid="input-invite-link"]').invoke('val').then((inviteLink) => {
    cy.writeFile('cypress/fixtures/invitateLink.json', { inviteLink })
  })
})

When("I go to the invitation link", () => {
  cy.readFile('cypress/fixtures/invitateLink.json')
  .then((data) => {
    cy.visit(data.inviteLink)
  })
})

Then("I should see the booth", () => {
  cy.contains("Question")
  cy.contains("Voter")
})
