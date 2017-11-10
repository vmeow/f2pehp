#152661608
@todo
Feature: Form Headings
  
    As a case worker,
    So that I can quickly find case information,
    I want to see Tax Form 13424-B and K headings.
    
    
Background: items have been added to database

    Given the following items exist:
      | client_ssn | client_name  | date_opened | date_closed | status |
      | 111111111  | John Doe     | 25-Nov-9999 | 2-Jan-2000  | closed |
      | 222222222  | Sally Sue    | 30-Nov-9999 |             | open   |
      | 333333333  | Billy Bob    | 11-Nov-9999 |             | open   |
      | 000000000  | Ender Wiggin | 11-Nov-9999 |             | open   |
 
@todo
Scenario: Opening new case
      Given I am on the new item page
      Then I should see "Form 13424-B"
      And I should see "Form 13424-K"
      Then I should see "Income Issues" after "Form 13424-B"
      And I should see "Collection Issues" before "Form 13424-K"
      And I should see "Case Inventory" after "Form 13424-K"
      And I should not see "Form 13424-K" before "Form 13424-B"

Scenario: On index page (no headers visible)
      Given I am on the items index page
      Then I should not see "Form 13424-B"
      And I should not see "Form 13424-K"

@todo
Scenario: Editing case
      Given I am on the edit item page for "222222222" 
      Then I should see "Form 13424-B"
      And I should see "Form 13424-K"
      And I should see "Income Issues" after "Form 13424-B"
      And I should see "Collection Issues" before "Form 13424-K"
      And I should see "Case Inventory" after "Form 13424-K"
      And I should not see "Form 13424-K" before "Form 13424-B"
