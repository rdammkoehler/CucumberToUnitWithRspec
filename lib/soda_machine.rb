class SodaMachine

  def initialize supplies={} 
    @supplies = supplies
    @balance = 0.0
    @change = 0.0
    @display = 0.0
    @unit_price = 0.75
    @unit_limit = 10
  end

  def << supplies
    extras = supplies.clone
    @supplies.merge!(supplies) { |key, orig, new| 
      if (orig + new) > @unit_limit
        return_value = @unit_limit
        extras[key] = orig + new - @unit_limit
      else
        return_value = orig + new 
      end
      return_value
    }
    extras
  end

  def contents
    @supplies
  end

  def purchase! type, money
    if have_supply? type 
      if balance_due? money 
        display_required money
      else
        dispense_pop type
        collect_payment
        reduce_supply type
        add_change calculate_overpayment(money)
      end
    else
      add_change money
    end
  end

  def display_required money
    @display = @unit_price - money
  end

  def balance_due? money
    money < @unit_price
  end

  def have_supply? type
    have?(type) and 
      count?(type) > 0
  end

  def have? type
    @supplies.keys.include? type
  end

  def dispense_pop type
    @vended = Pop.new type
  end

  def collect_payment
    @balance += @unit_price
  end

  def reduce_supply type
    @supplies[type] -= 1 if @supplies.keys.include? type
  end

  def calculate_overpayment amount_paid
    max(0, amount_paid - @unit_price)
  end

  def max a, b
    a > b ? a : b
  end

  def add_change amount
    @change += amount
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
    @supplies.delete_if { |type, count| count == @unit_limit }.empty?
  end

  def empty?
    @supplies.delete_if { |type, count| count == 0 }.empty?
  end

  def count? type
    @supplies[type] || 0
  end

end

class Pop

  def initialize type
    @type = type
  end

  def type
    @type
  end

  def eql? other
    @type == other.type
  end

end
