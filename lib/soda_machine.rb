class SodaMachine

  def initialize(supplies={})
    @supplies = supplies
    @balance = 0.0
    @change = 0.0
    @display = 0.0
    @unit_price = 0.75
    @unit_limit = 10
  end

  def <<(supplies)
    @supplies.merge!(supplies) { |k, o, n| 
      if (o + n) > @unit_limit
        r = @unit_limit
        supplies[k] = o + n - @unit_limit
      else
        r = o + n 
      end
      r
    }
    supplies
  end

  def contents
    @supplies
  end

  def purchase!(type, money)
    if @supplies.keys.include? type and 
        @supplies[type] > 0 
      if money >= @unit_price
        @vended = Pop.new(type)
        @balance += money
        @supplies[type] -= 1
        @change += money - @unit_price
      else
        @display = @unit_price - money
      end
    else
      @change += money
    end
  end

  def vend
    rval = @vended
    @vended = nil
    rval
  end

  def display
    @display
  end

  def change
    @change
  end

  def full?
    rval = true
    @supplies.keys.each { |type| 
      rval &= count?(type) == @unit_limit }
    rval
  end

  def empty?
    rval = true
    @supplies.keys.each { |type| rval &= count?(type) == 0 }
    rval
  end

  def count? type
    @supplies[type] || 0
  end

end

class Pop

  def initialize(type)
    @type = type
  end

  def type
    @type
  end

  def eql? other
    @type == other.type
  end

end
