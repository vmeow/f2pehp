Feature: Reopen an existing item
  
    As a case worker
    So that I can make updates to an existing item
    I want to be able to be able to reopen a item
    
  Background: items have been added to database

    Given the following items exist:
      | client_ssn | client_name  | date_opened | date_closed | status |
      | 111111111  | John Doe     | 25-Nov-9999 | 2-Jan-2000  | closed |
      | 222222222  | Sally Sue    | 30-Nov-9999 |             | open   |
      | 333333333  | Billy Bob    | 11-Nov-9999 |             | open   |
      | 000000000  | Ender Wiggin | 11-Nov-9999 |             | open   |
 
    Scenario: reopen an existing item
      Given I am on the edit page for "111111111"
      And I fill in "Date Closed" with ""
      And I press "Update Case"
      Then I should be on the items index page
      And the "date_closed" for "111111111" should be empty
     
  