Feature: Organize elections

  Scenario: Creation
    When User go to new election
    And User add a title and two choices
    Then Election should be created

  Scenario: Adding a voter
    Given I created an election
    When I add a user by email
    Then That user should be able to login and vote

  Scenario: Adding a voter
    Given I created an election
    And I invited Mario and Luigi
    And Mario and Luigi have voted
    When I compute the election's result
    Then The election's result is displayed
