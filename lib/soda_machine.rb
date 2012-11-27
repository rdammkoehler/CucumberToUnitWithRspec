class SodaMachine

  def initialize supplies={} 
    @supplies = supplies
    @change = 0.0
    @display = 0.0
    @unit_price = 75
    @unit_limit = 10
  end

  def << supplies
    extras = supplies.clone
    @supplies.merge!(supplies) { |key, have, add| 
      total_count = have + add
      if total_count > @unit_limit
        extras[key] = total_count - @unit_limit
        @unit_limit
      else
        total_count
      end
    }
    extras
  end

  def contents
    @supplies.clone.freeze
  end

  def purchase! type, money
    pennies = as_pennies money
    if have_supply? type 
      if balance_due? pennies
        display_required pennies
      else
        dispense_pop! type
        add_change calculate_overpayment(pennies)
      end
    else
      add_change pennies
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
    as_money @change
  end

  def full?
    @supplies.delete_if { |type, count| count == @unit_limit }.empty?
  end

  def empty?
    @supplies.delete_if { |type, count| count == 0 }.empty?
  end

  def quantity_of? type
    @supplies[type] || 0
  end

private

  def as_pennies money
    (money * 100).to_i
  end

  def as_money pennies
    (pennies.to_f / 100.0).to_f
  end

  def display_required pennies
    @display = as_money(@unit_price - pennies)
  end

  def balance_due? pennies
    pennies < @unit_price
  end

  def have_supply? type
    have?(type) and 
      quantity_of?(type) > 0
  end

  def have? type
    @supplies.keys.include? type
  end

  def dispense_pop! type
    @vended = Pop.new type
    reduce_supply! type
  end

  def reduce_supply! type
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
