Feature: Item Alert

	As a case worker
	So that I don't leave items unattended
	I want to receive an alert if a item has been open for over 90 days
 
	Background: items have been added to database

	Given the following items exist:
		| client_ssn | client_name  | date_opened |
		| 111111111  | John Doe     | 25-Nov-9999 |
		| 222222222  | Sally Sue    | 30-Nov-9999 |
		| 333333333  | Billy Bob    | 11-Nov-9999 |
		| 000000000  | Ender Wiggin | 11-Nov-1992 |


	Scenario: Receive alert for item after been open for 90 days
		Given I am on the items index page
		Then I should see "Case has been open for 90 days: 000000000"