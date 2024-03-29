class SodaMachine

  UNIT_LIMIT = 10
  UNIT_PRICE = 75

  def initialize supplies={} 
    @supplies = supplies
    @vended = []
    @change = 0.0
    @display = 0.0
    @balance = 0.0
  end

  def << supplies
    extras = supplies.clone
    @supplies.merge!(supplies) { |key, have, add| 
      total_count = have + add
      if total_count > UNIT_LIMIT
        extras[key] = total_count - UNIT_LIMIT
        UNIT_LIMIT
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
        @balance = pennies
        display_required pennies
      else
        dispense_pop! type
        clear_amount_due
        add_change calculate_overpayment(pennies)
        @balance = 0.0
      end
    else
      add_change pennies
    end
  end

  def vend
    @vended.pop
  end

  def display
    @display
  end

  def change
    dispensed = @change
    @change = 0.0
    as_money dispensed
  end

  def full?
    @supplies.delete_if { |type, count| count == UNIT_LIMIT }.empty?
  end

  def empty?
    @supplies.delete_if { |type, count| count == 0 }.empty?
  end

  def quantity_of? type
    @supplies[type] || 0
  end

private

  def clear_amount_due
    @display = 0.0
  end

  def as_pennies money
    (money * 100).to_i
  end

  def as_money pennies
    (pennies.to_f / 100.0).to_f
  end

  def display_required pennies
    @display = as_money(UNIT_PRICE - pennies)
  end

  def balance_due? pennies
    (@balance + pennies) < UNIT_PRICE
  end

  def have_supply? type
    have?(type) and 
      quantity_of?(type) > 0
  end

  def have? type
    @supplies.keys.include? type
  end

  def dispense_pop! type
    @vended.push Pop.new(type)
    reduce_supply! type
  end

  def reduce_supply! type
    @supplies[type] -= 1 if @supplies.keys.include? type
  end

  def calculate_overpayment amount_paid
    max(0, amount_paid - UNIT_PRICE)
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
