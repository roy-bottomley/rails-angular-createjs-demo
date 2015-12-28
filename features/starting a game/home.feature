Feature: Home
  When a user arrives at the website they should see the game

  @javascript
  Scenario: User arrives
    Given A user arrives at the root website
    Then They should see a deal cards button
    And They should see a game area
    And They should see a deck of cards
