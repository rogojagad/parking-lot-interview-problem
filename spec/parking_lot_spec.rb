# frozen_string_literal: true

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

  describe '#available_slot' do
    context 'empty slot available' do
      it 'returns the index of the first found empty slot' do
        slots = ['a', nil, 'b', 'c']

        allow(parking_lot).to receive(:slots).and_return(slots)

        expect(parking_lot.available_slot).to eq(1)
      end
    end

    context 'empty slot unavailable' do
      it 'returns nil' do
        slot = %w[a a a a]

        allow(parking_lot).to receive(:slots).and_return(slot)

        expect(parking_lot.available_slot).to eq(nil)
      end
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

  describe '#get_reg_numbers_by_color' do
    let(:car1) { instance_double Car }
    let(:car2) { instance_double Car }
    let(:car3) { instance_double Car }
    before do
      allow(car1).to receive(:reg_no).and_return('qwe')
      allow(car2).to receive(:reg_no).and_return('asd')
      allow(car3).to receive(:reg_no).and_return('zxc')
      allow(car1).to receive(:color).and_return('white')
      allow(car2).to receive(:color).and_return('black')
      allow(car3).to receive(:color).and_return('white')
    end

    it 'returns array of registration number' do
      slots = [car1, car2, car3]
      expected_array = %w[qwe zxc]

      allow(parking_lot).to receive(:slots).and_return(slots)
      result = parking_lot.get_reg_numbers_by_color 'white'
      expect(result).to eq(expected_array)
    end
  end

  describe '#get_slot_num_by_reg_no' do
    let(:car1) { instance_double Car }
    let(:car2) { instance_double Car }
    let(:car3) { instance_double Car }
    let(:slots) { [car1, car2, car3] }

    before do
      allow(car1).to receive(:reg_no).and_return('qwe')
      allow(car2).to receive(:reg_no).and_return('asd')
      allow(car3).to receive(:reg_no).and_return('zxc')

      allow(car1).to receive(:color).and_return('white')
      allow(car2).to receive(:color).and_return('black')
      allow(car3).to receive(:color).and_return('white')

      allow(parking_lot).to receive(:slots).and_return(slots)
    end

    context 'car with reg_no exist' do
      it 'returns slot number for corresponding reg_no' do
        result = parking_lot.get_slot_num_by_reg_no 'asd'
        expect(result).to eq('2')
      end
    end

    context 'car with reg_no not exist' do
      it 'returns nil' do
        result = parking_lot.get_slot_num_by_reg_no 'lkj'
        expect(result).to be_nil
      end
    end
  end

  describe 'get_slot_num_by_color' do
    let(:car1) { instance_double Car }
    let(:car2) { instance_double Car }
    let(:car3) { instance_double Car }
    let(:slots) { [car1, car2, car3] }

    before do
      allow(car1).to receive(:reg_no).and_return('qwe')
      allow(car2).to receive(:reg_no).and_return('asd')
      allow(car3).to receive(:reg_no).and_return('zxc')

      allow(car1).to receive(:color).and_return('white')
      allow(car2).to receive(:color).and_return('black')
      allow(car3).to receive(:color).and_return('white')

      allow(parking_lot).to receive(:slots).and_return(slots)
    end

    context 'car with this color exists' do
      it 'returns array of slot number' do
        expected_array = %w[1 3]

        result = parking_lot.get_slot_num_by_color 'white'

        expect(result).to eq(expected_array)
      end
    end

    context 'car with this color does not exist' do
      it 'returns empty array' do
        result = parking_lot.get_slot_num_by_color 'purple'

        expect(result.size).to eq(0)
      end
    end
  end
end
