import { Given, When, Then } from "@badeball/cypress-cucumber-preprocessor";

When("I go to new election", () => {
  cy.visit('http://localhost:19006/')
  cy.contains('Create an election').click()
})

When("I add a title", () => {
  cy.get('[data-testid="election-name"]').type(`Testing election from cypress`, {delay: 0})
})

When("I add choices", () => {
  let choices = [
    "First choice",
    "Second choice",
    "Third choice"
  ]

  for (let choice of choices) {
    cy.get('[data-testid="choice-list"]').contains('Add').click()
    cy.get('[data-testid="choice-name"]').type(choice, {delay: 0})
    cy.get('[data-testid="choice-modal"]').contains('Add').click()
  }
})

When("I click create", () => {
  cy.contains("Create").click()
})

Then("Election should be created", () => {
  cy.contains("Testing election from cypress")
})


