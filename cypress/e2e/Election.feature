Feature: Organize elections

  Scenario: Creation
    When I go to new election
    Then I should see 'You need at least 2 choices'
