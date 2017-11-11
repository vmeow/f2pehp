@todo
Feature: search for players in database

  As a aaa
  So that I can easily find specific players
  I want to search the database for players by name, account type

  Background: players have been added to the database

    Given the following items exist:
    | player_name | player_acc_type |
    | UncleTomas  | HC              |
    | Tyrone P    | Reg             | 

  Scenario: search for items by name
    When I fill in "Search Players" with "UncleTomas"
    And I press "Search"
    Then I should see "UncleTomas"

  Scenario: search for items by account type
    When I fill in "Search Cases" with "Reg"
    And I press "Search"
    Then I should see "Tyrone P"

    # search gem: https://github.com/activerecord-hackery/ransack