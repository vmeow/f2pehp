@todo
Feature:
    As a case worker
    So that I can reference tax filing forms easily
    I want to be able to enter all data from the 13424-B and 13424-K forms
    
Scenario: Check that the appropriate fields exist when creating a new case
  When PENDING
  Given I am on the new item page
  
  # Form 13424-B
  Then  I should see "Name of Clinic"
  And  I should see "Grant Year"
  And  I should see "Reporting Period"
  # Income Issues
  And  I should see "Wages"
  And  I should see "Interest/Dividends (Schedule B)"
  And  I should see "Business Income (Schedule C)"
  And  I should see "Capital Gain or Loss (Schedule D)"
  And  I should see "IRA / Pension"
  And  I should see "Social Security Benefits"
  And  I should see "Alimony"
  And  I should see "Rental, Royalty, Partnership, S Corp (Schedule E)"
  And  I should see "Farming Income (Schedule F)"
  And  I should see "Unemployment"
  And  I should see "Gambling Winnings"
  And  I should see "Cancellation of Debt"
  And  I should see "Settlement Proceeds"
  And  I should see "Other"
  # Deduction Issues
  And  I should see "Alimony"
  And  I should see "Education Expenses (Including student loan interest)"
  And  I should see "Moving Expenses"
  And  I should see "IRA Deduction"
  And  I should see "Medical and Dental Expenses"
  And  I should see "State and Local Taxes"
  And  I should see "Home Mortgage Interest"
  And  I should see "Other Interest Expenses"
  And  I should see "Charitable Contributions"
  And  I should see "Casualty and Theft Losses"
  And  I should see "Unreimbursed Employee Business Expenses"
  And  I should see "Other Itemized Deductions"
  And  I should see "Business Expenses (Schedule C)"
  # Credit Issues
  And  I should see "Child and Dependent Care Credit"
  And  I should see "Education Credits"
  And  I should see "Child Tax Credit / Additional Child Tax Credit"
  And  I should see "Earned Income Tax Credit"
  And  I should see "First-Time Homebuyer Credit"
  And  I should see "Premium Tax Credit"
  And  I should see "Other Credits"
  # Status Issues
  And  I should see "SSN / TIN"
  And  I should see "ITIN"
  And  I should see "Filing Status"
  And  I should see "Personal/Dependency Exemptions"
  And  I should see "Injured Spouse"
  And  I should see "Innocent Spouse"
  And  I should see "Employment-Related Identity Theft"
  And  I should see "Refund-Related Identity Theft"
  And  I should see "Nonfiler"
  And  I should see "Worker Classification"
  #Tax / Refund / Return / Statute of Limitations Issues
  And  I should see "Self-Employment Tax"
  And  I should see "Suspected Return Preparer Fraud"
  And  I should see "Estimated Tax Payments"
  And  I should see "Withholdings"
  And  I should see "Refund"
  And  I should see "Assessment Statute of Limitations"
  And  I should see "Collection Statute of Limitations"
  And  I should see "Refund Statute of Limitations"
  # Penalty and Addition to Tax Issues
  And  I should see "Trust Fund Recovery Penalty"
  And  I should see "Other Civil Penalties"
  And  I should see "Additional Tax on Distributions from Qualified Retirement Plans"
  And  I should see "Individual Shared Responsibility Payment"
  # Collection Issues
  And  I should see "Payments"
  And  I should see "Installment Payment Agreement (IPA)"
  And  I should see "Offer-In-Compromise (OIC)"
  And  I should see "Currently Not Collectible (CNC)"
  And  I should see "Liens"
  And  I should see "Levies (Including Federal Payment Levy Program)"
  
  # Form 13424-K
  Then I should see "Name of clinic"
  Then I should see "Grant year"
  Then I should see "Interim Report"
  Then I should see "Year-End Report"
  # Case Inventory
  Then I should see "Beginning case inventory"
  Then I should see "New cases opened during the reporting period"
  Then I should see "Total number of cases worked during the reporting period"
  Then I should see "Cases closed during the reporting period"
  Then I should see "Ending case inventory"
  # Accounts Management
  Then I should see "Return Processing"
  Then I should see "Penalty Abatement"
  Then I should see "Injured Spouse"
  Then I should see "Backup Withholding"
  # Exams
  Then I should see "Correspondence Exam"
  Then I should see "Office or Field Exam"
  Then I should see "Automated Underreporter"
  Then I should see "Automated Substitute-for-Return"
  Then I should see "Audit Reconsideration"
  # Collection
  Then I should see "Automated Collection System"
  Then I should see "Field Collection"
  Then I should see "Offer-In-Compromise"
  Then I should see "Lien Unit"
  Then I should see "Bankruptcy"
  # Appeals
  Then I should see "Exam Appeals"
  Then I should see "Collection Due Process"
  Then I should see "Collection Appeals Process"
  Then I should see "OIC Appeals"
  Then I should see "Penalty Abatement Appeals"
  Then I should see "Other Appeals"
  # Litigation
  Then I should see "U.S. Tax Court"
  Then I should see "Other Federal Courts"
  # Miscellaneous
  Then I should see "Identity Protection Specialized Unit"
  Then I should see "Innocent Spouse Unit"
  Then I should see "SS-8 Unit"
  Then I should see "ITIN Unit"
  Then I should see "Trust Fund Recovery Penalty"
  ## Additional Case Information
  ## For the cases reported on line 1B, indicate the number of cases where:
  And I should see "The amount in controversy exceeds $50,000 per tax period. (for cases reported on line 3, include an explanation for each in the Program Narrative, Item 3.vii)"
  And I should see "The taxpayer's income exceeds 250% of the federal poverty guidelines"
  ### For the cases reported on line 1C, indicate the number of cases involving:
  And I should see "Matters worked in more than on IRS function or U.S. court"
  And I should see "More than one tax year"
  And I should see "Representation of ESL taxpayers"
  And I should see "Joint representation of taxpayers"
  And I should see "Representation by volunteers"
  And I should see "State tax matters"
  ### U.S. Tax Court Activities 
  And I should see "Does the clinic participate in the U.S. Tax Court Clinical Program"
  And I should see "List the place(s) of trial location served:"
  And I should see "Number of U.S. Tax Court cases worked during the reporting period in which an appearance was entered pursuant to Tax Court Rule 24"
  And I should see "Number of U.S. Tax Court cases worked during the reporting period in which the clinic represented the taxpayer, but no appearance was entered"
  And I should see "Number of informal consultations in the U.S. Tax Court during the reporting period in which the clinic provided advice to a taxpayer, but not representation"
  ### Closed Case Outcomes
  ### For the cases reported on line 1D, indicate the:
  And I should see "A. Number of cases in which the taxpayer was brought into filing compliance"
  And I should see "B. Number of cases in which the taxpayer was brought into collection compliance"
  And I should see "C. Total amount of dollars refunded in cash to taxpayers"
  And I should see "D. Total decrease in corrected tax liabilities, penalties, and interest (but not below zero for any taxpayer)"
  