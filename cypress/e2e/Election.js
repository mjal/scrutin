import { Given, When, Then } from "@badeball/cypress-cucumber-preprocessor";

const baseUrl = 'http://localhost:19006/'

When("I go to new election", () => {
  cy.visit(baseUrl)
  cy.contains('Créer une élection').click()
})

When("I add a title", () => {
  cy.get('[data-testid="election-title"]').type(`Testing election from cypress`, { delay: 0 })
})

When("I add choices", () => {
  let choices = [
    "First choice",
    "Second choice",
  ]

  cy.get('[data-testid="choice-1"]').type(choices[0], { delay: 0 })
  cy.get('[data-testid="choice-2"]').type(choices[1], { delay: 0 })
})

When("I click next", () => {
  cy.contains("Suivant").click()
})

Then("Election should be created", () => {
  cy.contains("Testing election from cypress")
})

Given("I created an election", () => {
  cy.visit('http://localhost:19006/')
  cy.contains('Create an election').click()
  cy.get('[data-testid="election-title"]').type(`Testing election from cypress`, { delay: 0 })
  cy.contains("Next").click()
})

Given("I save trustees and identities", () => {
  cy.window().then(window => {
    let trustees = window.localStorage.getItem('trustees')
    let identities = window.localStorage.getItem('identities')

    cy.writeFile('cypress/fixtures/crendentials.json', {
      trustees,
      identities
    })
  })
})

Given("I clear localStorage", () => {
  cy.window().then(window => {
    window.localStorage.clear()
  })
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

//When("I invite {string} by email, with email notification", (email) => {
When("I invite {string} by email, with email notification", (email) => {
  cy.get('[data-testid="button-invite"]').click()
  cy.get('[data-testid="button-invite-email"]').click()
  cy.wait(1000)
  cy.get('[data-testid="input-invite-email-1"]').type(email, { delay: 0 })
  cy.contains('Inviter').click()
})

Given(/^a table step$/, (table) => {
  const expected = [
    ["Cucumber", "Cucumis sativus"],
    ["Burr Gherkin", "Cucumis anguria"]
  ];
  assert.deepEqual(table.raw(), expected);
})

When("I follow the link on {string} email", (email) => {
  cy.readFile('./auth/emails/' + email)
    .then((data) => {
      let data2 = JSON.parse(data)
      cy.visit(data2.link)
    })
})

When("I use the token", () => {
  cy.contains('Utiliser').click()
})

Then("I see the booth", () => {
  cy.contains("Question")
  cy.contains("Voter")
})
