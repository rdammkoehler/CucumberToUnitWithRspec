Feature: Fill Soda Machine
	 As a supplier
	 I want to fill the soda machine
	 So people can make purchases

	 Scenario: Fill Empty Machine
	 	   Given an empty soda machine
		   When I fill the machine
		   Then the machine is full

	Scenario: Fill a Partially Full Machine
		  Given a partially full soda machine
		  When I fill the machine
		  Then the machine is full
		  And the extra soda is not used

	Scenario: Can't Fill a Full Machine
		  Given a full soda machine
		  When I fill the machine
		  Then the machine is full