require 'spec_helper'

RSpec.describe ParkingSystem do
  subject(:parking_system) { ParkingSystem.new }

  describe '#receive_user_input' do
    it 'receives user input and stores to instance variable' do
      input_command = 'any_random_input'
      allow(STDIN).to receive(:gets) { input_command }

      parking_system.receive_user_input

      expect(parking_system.input).to eq(input_command)
    end
  end

  describe '#print_result' do
    it 'prints given result' do
      output = 'output string'
      expect(STDOUT).to receive(:puts).with(output)

      parking_system.print_result output
    end
  end

  describe '#to_num_or_nil' do
    context 'given string is convertable to int' do
      it 'returns int number of given string' do
        expect(parking_system.to_num_or_nil('231')).to eq(231)
      end
    end

    context 'given string is not convertable to int' do
      it 'returns nil' do
        expect(parking_system.to_num_or_nil('two')).to be_nil
      end
    end
  end

  describe '#create_parking_lot' do
    it 'create new parking lot with given size' do
      input = %w[create_parking_lot 5]

      allow(parking_system).to receive(:to_num_or_nil).with(input[1])
                                                      .and_return(5)

      parking_system.create_parking_lot(input)

      expect(parking_system.parking_lot.slots.size).to eq(5)
    end
  end

  describe '#leave_park_slot' do
    it 'deletes car on the corresponding slot' do
      parking_lot = double
      slot_num = Random.rand(1..10)

      allow(parking_system).to receive(:parking_lot).and_return(parking_lot)
      expect(parking_lot).to receive(:leave).with(slot_num)

      parking_system.leave_park_slot(slot_num)
    end
  end

  describe '#registration_numbers_by_color' do
    it 'retrieve reg_number of cars with corresponding color' do
      array = [
        'b 1234 a',
        'c 2345 b',
        'd 3456 d'
      ]
      size = array.size
      parking_lot = double
      color = 'white'

      allow(parking_system).to receive(:parking_lot).and_return(parking_lot)
      allow(parking_lot).to receive(:get_reg_numbers_by_color).with(color)
                                                              .and_return(array)

      expect(parking_system).to receive(:compact_to_string)
        .with(size, array)

      parking_system.registration_numbers_by_color color
    end
  end

  describe '#compact_to_string' do
    it 'coverts given array to suitable string format' do
      array = %w[
        qwe
        asd
        zxc
        dfgert
      ]

      size = array.size

      expected_string = 'qwe, asd, zxc, dfgert'

      result = parking_system.compact_to_string(size, array)

      expect(result).to eq(expected_string)
    end
  end
end
