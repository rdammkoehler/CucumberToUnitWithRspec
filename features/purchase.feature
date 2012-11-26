Feature: Purchase Soda With Various Amounts of Money
	 As a Soda Drinker
	 I want to use change to buy pop

	 Scenario: Exact Change
	 	   Given a soda machine
		   And it has soda
		   When I use exact change
		   Then I get a soda

	Scenario: Too Much Money
		  Given a soda machine
		  And it has soda
		  When I put in too much money
		  Then I get a soda
		  And I get correct change

	Scenario: Not Enough Money
		  Given a soda machine
		  And it has soda
		  When I put in too little money
		  Then I do not get a soda
		  And I am told how much more money I need to add

	Scenario: Machine is Empty
		  Given a soda machine
		  And it does not have soda
		  When I use exact change
		  Then I do not get a soda
		  And I get my money back