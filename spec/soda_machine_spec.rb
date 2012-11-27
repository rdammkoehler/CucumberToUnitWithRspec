require 'soda_machine'

describe "SodaMachine" do

  let(:machine) {
    SodaMachine.new
  }

  let(:supplies) {
    { :coke => 10, :dietcoke => 10, :sprite => 10, :water => 10 }
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
    loaded_machine.purchase! :coke, 0.75
    loaded_machine.vend.should eql Pop.new(:coke)
  end

  it "should accept exact change" do
    loaded_machine.purchase! :coke, 0.75
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
    loaded_machine.display.should be_within(Float::EPSILON).of(0.15)
  end

  it "should display the balance due (2)" do
    loaded_machine.purchase! :coke, 0.50
    loaded_machine.display.should eql 0.25
  end

  it "should return excess money" do
    loaded_machine.purchase! :coke, 0.80
    loaded_machine.change.should be_within(Float::EPSILON).of(0.05)
  end

  it "should accept pennies" do
    loaded_machine.purchase! :coke, 0.81
    loaded_machine.change.should be_within(Float::EPSILON).of(0.06)
  end

  it "should return pennies" do
    loaded_machine.purchase! :coke, 0.76
    loaded_machine.change.should be_within(Float::EPSILON).of(0.01)
  end

  it "should vend purchased soda" do
    loaded_machine.purchase! :coke, 0.75
    loaded_machine.vend.should eql Pop.new(:coke)
  end

  it "should return money when selection is empty" do
    machine.purchase! :coke, 0.75
    machine.change.should eql 0.75
  end

  it "should return money when selection does not exist" do
    loaded_machine.purchase! :dew, 0.75
    machine.change.should eql 0.75
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
    loaded_machine.count?(:coke).should eql 10
  end

  it "should provide a count of zero for a missing type" do
    loaded_machine.count?(:dew).should eql 0
  end

  it "should provide and indicator for full" do
    loaded_machine.full?.should be_true
  end

  it "should report not full when at least one Pop consumed" do
    loaded_machine.purchase! :coke, 0.75
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
    loaded_machine.purchase! :coke, 0.75
    loaded_machine << { :coke => 1 }
    loaded_machine.full?.should be_true
  end

end
