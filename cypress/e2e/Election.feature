Feature: Organize elections

  Scenario: Creation
    When I go to new election
    And I add a title
    And I add choices
    And I click next
    Then Election should be created

  Scenario: Adding a voter
    Given I created an election
    When I create an invitation link
    When I go to the invitation link
    Then I should see the booth

  @skip
  Scenario: Complete election
    Given I created an election
    And I invited Mario and Luigi
    And Mario and Luigi have voted
    When I compute the election's result
    Then The election's result is displayed
