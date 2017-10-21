Feature: Create Item
  
    As a case worker
    So that I can assist the CNSC's clients with their tax issues
    I want to be able to create a new item
  
Scenario: Create new item with basic item information
  Given I am on the new item page
  When  I fill in "Client SSN" with "1234567890"
  When  I fill in "Client Name" with "John Smith"
  And   I press "Create Item"
  Then  I should see "John Smith"
#  Then  The client_ssn of item "John Smith" should be "1234567890"