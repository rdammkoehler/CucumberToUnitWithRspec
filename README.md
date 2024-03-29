# Purpose

The purpose of this repo is to act as an example/explaination of how to move from Acceptance Tests to TDD activities.

## Step 1: Create An Acceptance Test

I started out by creating the _purchase.feature_ file with some basic scenarios about purchasing a soda \[inspred by my lust for Diet Coke\]. These scenarios describe the basic functioning of a soda-machine from the perspective of a soda drinker. This is, from the consumer's perspective, not the vendor.

I did my best to keep these scenario descriptions at a high level and avoid all the pitfalls of 'bad cucumber' that I could. 

Once I had created the feature file I ran cucumber and dutifuly filled in all the 'missing bits'.

1. I created a steps file
2. I pasted in the 'missing steps' from the cucumber output

After creating an empty steps file I set about making each step 'go green' by replacing the _pending_ calls with actual code.

The result of this was the defintion of my public interface for SodaMachine

```ruby
class SodaMachine

      def initialize supplies = {}
      end

      def << supplies
      end

      def purchase! type, money
      end

      def vend
      end

      def display
      end

      def change
      end

end
```

For each of these I then began identifying and developing tests TDD style using _rspec_.

Immediately I found that I needed a way to check the overall contents of the machine quickly so I added another public method

```ruby
	def contents
	end
```

I'm sure I missed a few edges but I then continued developing the code via _rspec_ and periodically ran the _cucumber_ tests to ensure I was on the right track. 

As I worked I came up with many thoughts about what was missing from the scenario list and worked to develop appropriate unit tests to cover those holes. Due to the lack of an _actual_ product owner I didn't add these to the feature because, in my opinion, they were not actually relevant to the Soda Drinker, thought they might have been to a business person who sells soda.

# Step 2: Create More Acceptance Tests

I ended up wanting __moar__ stuff in my world so I added another feature to cover some of the things that I thought were at least interesting to the Soda Machine scenario. So I created the _fillmachine.feature_ file. This was inspired by the freaquent case that I have consumed all available Diet Coke and am ruefully awaiting the delivery man. 

In part I guess this helped me flesh out the constructor and << methods.

As I worked through this feature to make my cucumber green again I added unit tests to the rspec one at a time until I had a green cucumber stack.

# Step 3: Clean Up

After I completed all the tests (that I was willing to build) I started the cleanup process. 

Throughout the development process I made minor adjustments to the code in terms of cleanness and made some minor refactors along the way. Once I had a fully green suite, I went back and made some more agressive refactorings. 

For one, I tried to get the purchase! method to be pretty close to english. I also looked over my ugly assertions and cleaned those up.

Exchaning this;
```ruby
(machine.change - 0.05).abs.should <= Float::EPSILON
```

With this;
```ruby
machine.change.should be_within(Float::EPSILON).of(0.05)
```

Honestly that's only nominally better in my opinion. 

So at lunch someone suggested that I convert the inputs to integers, do all my math with them, and return decimal 'money' like always. This resulted in assertions like this;

```ruby
machine.change.should be 0.05
```

So I did this. First I added a method _as_pennies_money_

```ruby
  def as_pennies money
    (money * 100).to_i
  end
```

And applied it to the input for _purchase!_type,_money_. Then I created the method _as_money_pennies_ and applied it to the outputs for _change_ and _display_required_pennies_.

```ruby
  def as_money pennies
    (pennies.to_f / 100.0).to_f
  end
```

I also had to change the constant _UNIT_PRICE_ from 0.75 to 75. Having done that I was able to get a nice clean assertion in steps and spec files. 

Along the way numerous other refactors and redesigns occured. The public API pretty much stayed the same throughout, though I did change _count_ to _quantity_of?_ to improve readability.

I also introduced various constants, added a few more tests for things I didn't think of and generally made the code as clean as I could.

Once I was satisfied with the code I added a Rake file so I could stop typing 

```bash
rspec && cucumber
```
# Step 4: Explaining It All

So the purpose was to expose the process of how to go from Acceptance Tests down to TDD (and back). Above is sort of a light transcript of my activities. But what is the salient point I'm trying to express?

For me at least, starting with the feature and just trying to get things to 'go green' in order was enought to cue me into when I needed to drop down to a more TDD level. 

When I wrote
```ruby
When /^I fill the machine$/ do
  @left_overs = @machine << { :coke => 10, :dietcoke => 10, :sprite => 10, :water => 10 }
end
```

I _knew_ it was time to write
```ruby
  it "should accept collection of soda" do
    supplies = Hash[ :coke => 10, :dietcoke =>10, :sprite =>10, :water => 10 ]
    loaded_machine = SodaMachine.new
    loaded_machine << supplies
    loaded_machine.contents.should eql supplies
  end
```

What was my congnitive process here? Good question. I've been struggling to articulate it. 

1. I had the feature file for purchase. 
1. I created the steps file
1. I started filling in the _pending_ sections of the steps.
1. Each time I added a step I tried running the cucumber.
1. When cucumber failed because the associated code didn't exist, I created it. (Just like TDD)
1. For each new bit of code I attempted to test drive that code by creating a spec for it. (I admit that I had a preconceived notion of what the unit tests would be, but I found that my preconceived idea was incomplete, as usual). 
1. After creating the code to get cucumber and the assocaiated specs green I moved on to the next step.
1. After completing the cucumber and specs I reviewed to see what I'd missed. (Boy do I wish I had a pair while doing this)
1. Afer plugging as many holes as I could find I started cleaning up the code, shaping it as best I could (at this point I did get a pair, sort of)
1. Then I went back and reviewed my feature files, steps file, and spec file both for cleanliness and completelness. This led to lots of little actions like the design change to use integers internally, defining constants, renaming things etc.

So I feel like I've watered down the 'cognative' process to a mechanical one. But practicing the mechanical one I suspect will reveal what's going on in my head.


The end.

