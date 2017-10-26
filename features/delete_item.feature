Feature: Delete Item
  
    As a case worker,
    So that I can organize the case database,
    I want to be able to delete an item.
    
    Background: items have been added to database
      
    Given the following items exist:
    | client_ssn | client_name  | date_opened | date_closed | status |
    | 111111111  | John Doe     | 25-Nov-9999 | 2-Jan-2000  | closed |
    | 222222222  | Sally Sue    | 30-Nov-9999 |             | open   |
    | 333333333  | Billy Bob    | 11-Nov-9999 |             | open   |
    | 000000000  | Ender Wiggin | 11-Nov-9999 |             | open   |
    
Scenario: Delete an item
      Given I am on the edit item page for "222222222"
      Given PENDING
      And I press "Delete Case"
      Then I should be on the items index page
      And I should not see "222222222"
      