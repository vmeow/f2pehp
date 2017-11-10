@todo
Feature:
    As a case worker
    So that I can reference tax filing forms easily
    I want to be able to enter all data from the 13424-B and 13424-K forms
    
Scenario: Check that the appropriate fields exist when creating a new case
  Given I am on the new item page
  
  # Form 13424-B
  # Income Issues
  Then I should see "1. Wages"
  And  I should see "2. Interest / Dividends (Schedule B)"
  And  I should see "3. Business Income (Schedule C)"
  And  I should see "4. Capital Gain or Loss (Schedule D)"
  And  I should see "5. IRA / Pension"
  And  I should see "6. Social Security Benefits"
  And  I should see "7. Alimony"
  And  I should see "8. Rental, Royalty, Partnership, S Corp (Schedule E)"
  And  I should see "9. Farming Income (Schedule F)"
  And  I should see "10. Unemployment"
  And  I should see "11. Gambling Winnings"
  And  I should see "12. Cancellation of Debt"
  And  I should see "13. Settlement Proceeds"
  And  I should see "14. Other"
  # Deduction Issues
  And  I should see "15. Alimony"
  And  I should see "16. Education Expenses (Including student loan interest)"
  And  I should see "17. Moving Expenses"
  And  I should see "18. IRA Deduction"
  And  I should see "19. Medical and Dental Expenses"
  And  I should see "20. State and Local Taxes"
  And  I should see "21. Home Mortgage Interest"
  And  I should see "22. Other Interest Expenses"
  And  I should see "23. Charitable Contributions"
  And  I should see "24. Casualty and Theft Losses"
  And  I should see "25. Unreimbursed Employee Business Expenses"
  And  I should see "26. Other Itemized Deductions"
  And  I should see "27. Business Expenses (Schedule C)"
  # Credit Issues
  And  I should see "28. Child and Dependent Care Credit"
  And  I should see "29. Education Credits"
  And  I should see "30. Child Tax Credit / Additional Child Tax Credit"
  And  I should see "31. Earned Income Tax Credit"
  And  I should see "32. First-Time Homebuyer Credit"
  And  I should see "33. Premium Tax Credit"
  And  I should see "34. Other Credits"
  # Status Issues
  And  I should see "35. SSN / TIN"
  And  I should see "36. ITIN"
  And  I should see "37. Filing Status"
  And  I should see "38. Personal / Dependency Exemptions"
  And  I should see "39. Injured Spouse"
  And  I should see "40. Innocent Spouse"
  And  I should see "41. Employment-Related Identity Theft"
  And  I should see "42. Refund-Related Identity Theft"
  And  I should see "43. Nonfiler"
  And  I should see "44. Worker Classification"
  # Tax Issues
  And  I should see "45. Self-Employment Tax"
  And  I should see "46. Suspected Return Preparer Fraud"
  And  I should see "47. Estimated Tax Payments"
  And  I should see "48. Withholdings"
  And  I should see "49. Refund"
  And  I should see "50. Assessment Statute of Limitations"
  And  I should see "51. Collection Statute of Limitations"
  And  I should see "52. Refund Statute of Limitations"
  # Penalty Issues
  And  I should see "53. Trust Fund Recovery Penalty"
  And  I should see "54. Other Civil Penalties"
  And  I should see "55. Additional Tax on Distributions from Qualified Retirement Plans"
  And  I should see "56. Individual Shared Responsibility Payment"
  # Collection Issues
  And  I should see "57. Payments"
  And  I should see "58. Installment Payment Agreement (IPA)"
  And  I should see "59. Offer In Compromise (OIC)"
  And  I should see "60. Currently Not Collectible (CNC)"
  And  I should see "61. Liens"
  And  I should see "62. Levies (Including Federal Payment Levy Program)"
  And  I should see "Total Case Issues Worked (add lines 1 through 62)"
  
  # Form 13424-K
  # Case Inventory
  And  I should see "1A. Beginning case inventory(the number of cases that were worked in the previous year that remained open as of the first day of the reporting period)"
  And  I should see "1B. New cases opened during the reporting period"
  And  I should see "1C. Total number of cases worked during the reporting period (add lines 1A and 1B)"
  And  I should see "1D. Cases closed during the reporting period"
  And  I should see "1E. Ending case inventory (the number of cases that remained open as of the last day of the reporting period (subtract line 1D from line 1C))"
  # Accounts Management
  And  I should see "2A. Return Processing"
  And  I should see "2B. Penalty Abatement"
  And  I should see "2C. Injured Spouse"
  And  I should see "2D. Backup Withholding"
  # Exams
  And  I should see "2E. Correspondence Exam"
  And  I should see "2F. Office or Field Exam"
  And  I should see "2G. Automated Underreporter (AUR)"
  And  I should see "2H. Automated Substitute-for-Return (ASFR)"
  And  I should see "2I. Audit Reconsideration"
  # Collection
  And  I should see "2J. Automated Collection System (ACS)"
  And  I should see "2K. Field Collection (RO)"
  And  I should see "2L. Offer-In-Compromise (OIC)"
  And  I should see "2M. Lien Unit"
  And  I should see "2N. Bankruptcy"
  # Appeals
  And  I should see "2O. Exam Appeals"
  And  I should see "2P. Collection Due Process (CDP)"
  And  I should see "2Q. Collection Appeals Process (CAP)"
  And  I should see "2R. OIC Appeals"
  And  I should see "2S. Penalty Abatement Appeals"
  And  I should see "2T. Other Appeals"
  # Litigation
  And  I should see "2U. U.S. Tax Court"
  And  I should see "2V. Other Federal Courts"
  # Miscellaneous
  And  I should see "2W. Identity Protection Specialized Unit (IPSU)"
  And  I should see "2X. Innocent Spouse Unit"
  And  I should see "2Y. SS-8 Unit"
  And  I should see "2Z. ITIN Unit"
  And  I should see "2AA. Trust Fund Recovery Penalty"
  And  I should see "TOTAL (add items 2A through 2AA) (Must equal value in line 1C)"
  # Additional Case Information
  And  I should see "3. The amount in controversy exceeds $50,000 per tax period. (for cases reported on line 3, include an explanation for each in the Program Narrative, Item 2.vii)"
  And  I should see "4. The taxpayer's income exceeds 250% of the federal poverty guidelines"
  And  I should see "5. Matters worked in more than on IRS function or U.S. court"
  And  I should see "6. More than one tax year"
  And  I should see "7. Representation of ESL taxpayers"
  And  I should see "8. Joint representation of taxpayers"
  And  I should see "9. Representation by volunteers"
  And  I should see "10. State tax matters"
  # U.S. Tax Court Activities
  And  I should see "12. Number of U.S. Tax Court cases worked during the reporting period in which an appearance was entered pursuant to Tax Court Rule 24"
  And  I should see "13. Number of U.S. Tax Court cases worked during the reporting period in which the clinic represented the taxpayer, but no appearance was entered"
  And  I should see "14. Number of informal consultations in the U.S. Tax Court during the reporting period in which the clinic provided advice to a taxpayer, but not representation"
  # Closed Case Outcomes
  And  I should see "15A. Number of cases in which the taxpayer was brought into filing compliance"
  And  I should see "15B. Number of cases in which the taxpayer was brought into collection compliance"
  And  I should see "15C. Total amount of dollars refunded in cash to taxpayers"
  And  I should see "15D. Total decrease in corrected tax liabilities, penalties, and interest (but not below zero for any taxpayer)"