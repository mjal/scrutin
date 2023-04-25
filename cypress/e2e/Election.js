import { Given, When, Then } from "@badeball/cypress-cucumber-preprocessor";

When("I go to new election", () => {
  cy.visit('http://localhost:19006/')
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


