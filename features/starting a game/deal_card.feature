Feature: Deal
When a user is playing a game they should be able to deal cards

  @javascript
  Scenario: dealing cards
    Given A user arrives at the root website
    Then The number of dealt cards should be "0"
    And There should not be a card in the dealt position
    When The user clicks the deal card button
    Then The number of dealt cards should be "1"
    And There should  be a card in the dealt position
