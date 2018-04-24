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
end
