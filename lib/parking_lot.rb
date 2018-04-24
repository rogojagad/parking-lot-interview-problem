class ParkingLot
  attr_accessor :slots
  def initialize(size)
    @slots = Array.new(size)
  end

  def park(car:, slot_num:)
    slots[slot_num] = car
  end

  def leave(slot_num)
    slots[slot_num] = nil
  end

  def get_reg_numbers_by_color(color)
    result = []
    slots.each do |slot|
      next unless slot
      result << slot.reg_no if slot.color == color
    end

    result
  end
end
