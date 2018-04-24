require 'spec_helper'

RSpec.describe ParkingLot do
  let(:slots_size) { Random.rand(3..10) }
  subject(:parking_lot) { ParkingLot.new slots_size }

  describe '#initialize and attr_accessor' do
    it 'receives size' do
      parking_lot = ParkingLot.new slots_size
      expect(parking_lot.slots.size).to eq(slots_size)
    end
  end

  describe '#park' do
    it 'park car object on empty slot' do
      slot_num = slots_size - 1
      car = double

      parking_lot.park(car: car, slot_num: slot_num)

      expect(parking_lot.slots[slot_num]).to eq(car)
    end
  end

  describe '#leave' do
    let(:slot_num) { slots_size - 1 }

    before do
      car = double
      parking_lot.slots[slot_num] = car
    end

    it 'nullified parking lot with corresponding index' do
      parking_lot.leave(slot_num)

      expect(parking_lot.slots[slot_num]).to be_nil
    end
  end
end
