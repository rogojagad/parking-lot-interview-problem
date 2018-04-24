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
end
