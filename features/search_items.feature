@todo
Feature: search for items in database

  As a case worker
  So that I can easily find specific items
  I want to search the database for cases by SSN, name, and case number

  Background: items have been added to the database

    When PENDING
    Given the following items exist:
      | client_ssn | client_name  | date_opened | date_closed | status | case_id      |
      | 111111111  | John Doe     | 25-Nov-9999 | 2-Jan-2000  | closed | 2017-06-0000 |
      | 222222222  | Sally Sue    | 30-Nov-9999 |             | open   | 2017-06-0101 |
      | 333333333  | Billy Bob    | 11-Nov-9999 |             | open   | 2014-01-1000 |
      | 000000000  | Ender Wiggin | 11-Nov-9999 |             | open   | 1999-04-0001 |

    And I am on the items index page

  Scenario: search for items by SSN
    When I fill in "search_bar" with "000000000"
    And I press "search"
    Then I should see "Ender Wiggin"

  Scenario: search for items by client name
    When I fill in "search_bar" with "Ender Wiggin"
    And I press "search"
    Then I should see "000000000"

  Scenario: search for items by case number
    When I fill in "search_bar" with "2017-06-0000"
    And I press "search"
    Then I should see "Ender Wiggin"

    # search gem: https://github.com/activerecord-hackery/ransack

