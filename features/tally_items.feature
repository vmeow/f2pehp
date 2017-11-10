Feature: Tally Items By Issue
  As a case worker
  So that I can quickly complete tax forms
  I want to be able to count and view cases of a certain issue type
  
  Background: Items have been added to the database
    
    Given the following items exist:
      | client_ssn | client_name | income_issues_wages | income_issues_ira_pension | deduction_issues_other_interest_expenses |
      | 111111111  | John        | 0                   | 0                         | 0                                        |
      | 222222222  | Mary        | 1                   | 0                         | 0                                        |
      | 333333333  | young Money | 0                   | 1                         | 1                                        |
      | 444444444  | mike        | 1                   | 0                         | 1                                        |
    
    @todo
    Scenario: Sort by Income Wages Issue
      When PENDING
      Given I am on the diagnostics page
      When I check "income_issues_wages"
      And I uncheck "income_issues_ira_pension"
      And I uncheck "deduction_issues_other_interest_expenses"
      And I press "Filter"
      Then I should see "Mary"
      And I should see "mike"
      And I should not see "John"
      And I should not see "young Money"
      And I should see "Total Cases: 2"
      
    @todo
    Scenario: Sort by Income Wages Issue and Income IRA Pension Issue
      When PENDING
      Given I am on the diagnostics page
      When I check "income_issues_wages"
      And I check "income_issues_ira_pension"
      And I uncheck "deduction_issues_other_interest_expenses"
      And I press "Filter"
      Then I should see "Mary"
      And I should see "young Money"
      And I should see "mike"
      And I should not see "John"
      And I should see "Total Cases: 3"
      
    @todo
    Scenario: Uncheck all relevant issues
      When PENDING
      Given I am on the diagnostics page
      When I uncheck "income_issues_ira_pension"
      And I uncheck "income_issues_wages"
      And I uncheck "deduction_issues_other_interest_expenses"
      And I press "Filter"
      Then I should not see "Mary"
      And I should not see "young Money"
      And I should not see "mike"
      And I should not see "John"
      And I should see "Total Cases: 0"
      