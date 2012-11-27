$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'soda_machine'

UNIT_LIMIT = 10
UNIT_PRICE = 0.75

Given /^an empty soda machine$/ do
  @machine = SodaMachine.new
end

When /^I fill the machine$/ do
  @left_overs = @machine << { :coke => UNIT_LIMIT, :dietcoke => UNIT_LIMIT, :sprite => UNIT_LIMIT, :water => UNIT_LIMIT }
end

Then /^the machine is full$/ do
  @machine.should be_full
end

Given /^a partially full soda machine$/ do
  @machine = SodaMachine.new({ :coke => 5, :dietcoke => 5, :sprite => 5, :water => 5 })
end

Then /^the extra soda is not used$/ do
  @left_overs.should eql Hash[ :coke => 5, :dietcoke => 5, :sprite => 5, :water => 5 ]
end

Given /^a full soda machine$/ do
  @machine = SodaMachine.new({ :coke => UNIT_LIMIT, :dietcoke => UNIT_LIMIT, :sprite => UNIT_LIMIT, :water => UNIT_LIMIT })
end

Given /^a soda machine$/ do
  @machine = SodaMachine.new
end

Given /^it has soda$/ do
  @machine << { :coke => UNIT_LIMIT, :dietcoke => UNIT_LIMIT, :sprite => UNIT_LIMIT, :water => UNIT_LIMIT }
end

When /^I use exact change$/ do
  @machine.purchase! :dietcoke, UNIT_PRICE
end

Then /^I get a soda$/ do
  @machine.vend().should_not be_nil
end

When /^I put in too much money$/ do
  @machine.purchase! :dietcoke, 0.80
end

Then /^I get correct change$/ do
  @machine.change.should eql 0.05
end

When /^I put in too little money$/ do
  @machine.purchase! :dietcoke, 0.60
end

Then /^I do not get a soda$/ do
  @machine.vend().should be_nil
end

Then /^I am told how much more money I need to add$/ do
  @machine.display.should eql 0.15
end

Given /^it does not have soda$/ do
  @machine << {}
end

Then /^I get my money back$/ do
  @machine.change.should eql UNIT_PRICE
end
