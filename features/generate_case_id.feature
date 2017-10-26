Feature: Close Item
  
    As a case worker,
    So that I can refer to unique cases,
    I want to automatically generate case IDs.
    
    

 
Scenario: Generate Case ID upon Case Creation
      Given I am on the items index page
      Then  I should not see "201212"

      Given I am on the new item page
      When  I fill in "Client SSN" with "101010101"
      When  I fill in "Client Name" with "Billy Bob Joe Jr"
      And   I select "2012/December/1" as the date for "date_opened"
      And   I press "Create Item"
      Then  I should match "[0-9]* *101010101"
      And   I should see "201212"
      
      