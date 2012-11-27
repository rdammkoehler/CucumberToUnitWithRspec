require 'soda_machine'

describe "SodaMachine" do

  UNIT_LIMIT = 10
  UNIT_PRICE = 0.75

  let(:machine) {
    SodaMachine.new
  }

  let(:supplies) {
    { :coke => UNIT_LIMIT, :dietcoke => UNIT_LIMIT, :sprite => UNIT_LIMIT, :water => UNIT_LIMIT }
  }

  let(:loaded_machine) {
    machine << supplies
    machine
  }

  it "should accept collection of soda" do
    loaded_machine.contents.should eql supplies
  end

  it "should accept an empty collection of soda" do
    machine << {}
    machine.contents.should be_empty
  end

  it "should allow purchases of soda" do
    loaded_machine.purchase! :coke, UNIT_PRICE
    loaded_machine.vend.should eql Pop.new(:coke)
  end

  it "should accept exact change" do
    loaded_machine.purchase! :coke, UNIT_PRICE
    loaded_machine.vend.should_not be_nil
  end

  it "should accept too much money" do
    loaded_machine.purchase! :coke, 0.80
    loaded_machine.vend.should_not be_nil
  end

  it "should accept too little money" do
    loaded_machine.purchase! :coke, 0.60
    loaded_machine.vend.should be_nil
  end

  it "should display the balance due" do
    loaded_machine.purchase! :coke, 0.60
    loaded_machine.display.should eql 0.15
  end

  it "should display the balance due (2)" do
    loaded_machine.purchase! :coke, 0.50
    loaded_machine.display.should eql 0.25
  end

  it "should return excess money" do
    loaded_machine.purchase! :coke, 0.80
    loaded_machine.change.should eql 0.05
  end

  it "should accept pennies" do
    loaded_machine.purchase! :coke, 0.81
    loaded_machine.change.should eql 0.06
  end

  it "should return pennies" do
    loaded_machine.purchase! :coke, 0.76
    loaded_machine.change.should eql 0.01
  end

  it "should vend purchased soda" do
    loaded_machine.purchase! :coke, UNIT_PRICE
    loaded_machine.vend.should eql Pop.new(:coke)
  end

  it "should return money when selection is empty" do
    machine.purchase! :coke, UNIT_PRICE
    machine.change.should eql UNIT_PRICE
  end

  it "should return money when selection does not exist" do
    loaded_machine.purchase! :dew, UNIT_PRICE
    machine.change.should eql UNIT_PRICE
  end

  it "should accumulate change" do
    loaded_machine.purchase! :coke, 1.00
    loaded_machine.purchase! :coke, 1.00
    loaded_machine.purchase! :coke, 1.00
    loaded_machine.change.should eql 0.75
  end

  it "should return extra soda" do
    machine << { :coke => 8, :dietcoke => 2 }
    extra = machine << { :coke => 5, :dietcoke => 12 }
    extra.should eql Hash[ :coke => 3, :dietcoke => 4 ]
  end

  it "should provide a count of soda by type" do
    loaded_machine.quantity_of?(:coke).should eql UNIT_LIMIT
  end

  it "should provide a count of zero for a missing type" do
    loaded_machine.quantity_of?(:dew).should eql 0
  end

  it "should provide and indicator for full" do
    loaded_machine.full?.should be_true
  end

  it "should report not full when at least one Pop consumed" do
    loaded_machine.purchase! :coke, UNIT_PRICE
    loaded_machine.full?.should be_false
  end

  it "should provide and indicator for empty" do
    machine.empty?.should be_true
  end

  it "should report not empty when at least one Pop remains" do
    machine << { :coke => 1 }
    machine.empty?.should be_false
  end

  it "should report full after reloading" do
    loaded_machine.purchase! :coke, UNIT_PRICE
    loaded_machine << { :coke => 1 }
    loaded_machine.full?.should be_true
  end

  it "should ignore negative purchase money" do
    pending
  end

  it "should never return less than zero change" do
    pending
  end

  it "should clear the display when the correct amount of money is provided" do
    pending
  end

  it "should add the input money to the change on purchase if vend wasn't called" do
    pending
  end

  it "should zero out change after change is called" do
    pending
  end

end
