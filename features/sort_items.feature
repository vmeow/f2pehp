Feature: Sort Items
  As a case worker
  So that I can find the item I'm looking for
  I want to be able to sort items by SSN or Name

  Background: items have been added to database

    Given the following items exist:
      | client_ssn | client_name | date_opened |
      | 111111111  | John Doe    | 25-Nov-1992 |
      | 222222222  | Sally Sue   | 30-Nov-1992 |
      | 333333333  | Billy Bob   | 11-Nov-1992 |

  Scenario: Sort by SSN
    Given I am on the items index page
    When I press "client_ssn"
    Then I should see "111111111" before "222222222"
    And I should see "222222222" before "333333333"
    And I should not see "333333333" before "111111111"

  Scenario: Sort by Name
    Given I am on the items index page
    When I press "client_name"
    Then I should see "Billy Bob" before "John Doe"
    And I should see "John Doe" before "Sally Sue"
    And I should not see "Sally Sue" before "Billy Bob"

