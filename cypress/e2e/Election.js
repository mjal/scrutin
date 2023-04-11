import { When, Then } from "@badeball/cypress-cucumber-preprocessor";

When("I go to new election", () => {
  cy.visit('http://localhost:19006/')
  cy.contains('Create a new election').click()
})

Then("I should see 'You need at least 2 choices'", () => {
  cy.contains("You need at least 2 choices")
})
