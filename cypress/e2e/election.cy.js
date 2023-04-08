describe('election', () => {
  it('create an election', () => {
    cy.visit('http://localhost:19006/')
    cy.intercept("https://scrutin-staging.fly.dev/transactions")

    cy.contains('Create a new election').click()
    cy.get('[data-testid="election-name"]').type(`Testing election from cypress`, {delay: 0})

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

    cy.contains("Create").click()
    cy.contains("Testing election from cypress")

    let voters = [
      "someone@somedomainthatdoesntexist.com",
      "someoneelse@somedomainthatdoesntexist.com",
      "athirdperson@somedomainthatdoesntexist.com",
    ]

    let crendentials = []

    for (let voter of voters) {
      cy.contains('Add someone').click()
      cy.get('[data-testid="voter-email"]').type(voter, {delay: 0})
      cy.contains('Send invite by email').click()
      cy.window().then(window => {
        crendentials.push({
          hexSecretKey: window.hexSecretKey,
          ballotId: window.ballotId
        })
      })
    }

    let electionId = ""
    cy.window().then(window => {
      electionId = window.electionId

      let trustees = window.localStorage.getItem('trustees')
      let identities = window.localStorage.getItem('identities')

      cy.writeFile('cypress/fixtures/crendentials.json', {
        electionId,
        crendentials,
        trustees,
        identities
      })
    })
  })

  it('cannot vote without credentials', () => {
    cy.readFile('cypress/fixtures/crendentials.json').then((o) => {
      let credential = o.crendentials[0]
      cy.visit(`http://localhost:19006/ballots/${credential.ballotId}`)
      cy.contains("You don't have voting right")
      cy.visit(`http://localhost:19006/`)
    })
  })

  it('vote by url', () => {
    cy.readFile('cypress/fixtures/crendentials.json').then((o) => {
      let os = o.crendentials.map((o) => {
        o.choiceText = 'Third choice';
        return o
      })
      os[1].choiceText = 'First choice'
      for (let o of os) {
        cy.log(o)
        cy.visit(`http://localhost:19006/ballots/${o.ballotId}#${o.hexSecretKey}`)
        cy.contains(o.choiceText).click()
        cy.contains('Vote').click()
        cy.wait(1000)
        cy.visit(`http://localhost:19006/`)
      }
    })
  })

  it('tally', () => {
    cy.readFile('cypress/fixtures/crendentials.json').then((o) => {
      cy.visit(`http://localhost:19006/`)
      cy.window().then(window => {
        window.localStorage.setItem('trustees', o.trustees)
        window.localStorage.setItem('identities', o.identities)
      })
      cy.visit(`http://localhost:19006/elections/${o.electionId}`)
      cy.contains("Close election and tally").click()
      cy.wait(2000)
    })
  })
})
