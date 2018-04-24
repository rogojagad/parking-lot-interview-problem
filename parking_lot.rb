class ParkingLot
  attr_accessor :slots
  def initialize(size)
    @slots = Array.new(size)
  end
end
