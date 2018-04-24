require 'spec_helper'

RSpec.describe ParkingSystem do
  subject(:parking_system) { ParkingSystem.new }

  describe '#run' do
    context 'system argument given' do
      it 'runs in file mode' do
        ARGV.replace ['filename']
        expect(parking_system).to receive(:file_mode)
        parking_system.run
      end
    end

    context 'system argument not given' do
      it 'runs in interactive mode' do
        ARGV.replace [nil]
        expect(parking_system).to receive(:interactive_mode)
        parking_system.run
      end
    end
  end

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

  describe 'str_to_int' do
    context 'given string is convertable to int' do
      it 'returns int number' do
        expect(parking_system.str_to_int('2')).to eq(2)
      end
    end

    context 'given string is not convertable' do
      it 'exit_execution' do
        expect(parking_system).to receive(:exit_execution)
        parking_system.str_to_int('two')
      end
    end
  end

  describe '#create_parking_lot' do
    it 'create new parking lot with given size' do
      input = %w[create_parking_lot 5]

      allow(parking_system).to receive(:str_to_int).with(input[1])
                                                   .and_return(5)

      parking_system.create_parking_lot(input)

      expect(parking_system.parking_lot.slots.size).to eq(5)
    end
  end

  describe '#leave_park_slot' do
    it 'deletes car on the corresponding slot' do
      parking_lot = double
      slot_num = Random.rand(1..10)

      allow(parking_system).to receive(:parking_lot)
        .and_return(parking_lot)
      expect(parking_lot).to receive(:leave).with(slot_num)

      parking_system.leave_park_slot(slot_num)
    end
  end

  describe '#leave_process' do
    it 'check condition to leave parking slot properly' do
      allow(parking_system).to receive(:str_to_int).with('5')
                                                   .and_return(5)
      expect(parking_system).to receive(:leave_park_slot).with(4)
      expect(parking_system).to receive(:print_result)
        .with('Slot number 5 is free')

      parking_system.leave_process '5'
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

      allow(parking_system).to receive(:parking_lot)
        .and_return(parking_lot)
      allow(parking_lot).to receive(:get_reg_numbers_by_color)
        .with(color)
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

  describe '#slot_numbers_by_color' do
    it 'retrieve slot number of cars with corresponding color' do
      array = [1, 3, 4]
      size = array.size
      parking_lot = double
      color = 'white'

      allow(parking_system).to receive(:parking_lot)
        .and_return(parking_lot)
      allow(parking_lot).to receive(:get_slot_num_by_color)
        .with(color)
        .and_return(array)

      expect(parking_system).to receive(:compact_to_string)
        .with(size, array)

      parking_system.slot_numbers_by_color color
    end
  end

  describe '#slot_num_by_registration_number' do
    let(:parking_lot) { double }
    let(:reg_no) { 'qwe 123 asd' }

    context 'registration number exist' do
      it 'returns slot number in string' do
        slot_num = Random.rand(1..10).to_s

        allow(parking_system).to receive(:parking_lot)
          .and_return(parking_lot)
        allow(parking_lot).to receive(:get_slot_num_by_reg_no)
          .with(reg_no)
          .and_return(slot_num)

        result = parking_system.slot_num_by_registration_number(reg_no)

        expect(result).to eq(slot_num)
      end
    end

    context 'registration number not exist' do
      it 'returns not found string' do
        allow(parking_system).to receive(:parking_lot)
          .and_return(parking_lot)
        allow(parking_lot).to receive(:get_slot_num_by_reg_no)
          .with(reg_no)
          .and_return(nil)

        result = parking_system.slot_num_by_registration_number(reg_no)

        expect(result).to eq('Not found')
      end
    end
  end

  describe '#park_on_slot' do
    it 'parks new car in an empty slot' do
      car = double
      parking_lot = double
      reg_no = 'b 6213 z'
      color = 'black'
      slot_num = Random.rand(1...5)
      expect(Car).to receive(:new).with(reg_no: reg_no, color: color)
                                  .and_return(car)

      allow(parking_system).to receive(:parking_lot)
        .and_return(parking_lot)
      expect(parking_lot).to receive(:park).with(car: car,
                                                 slot_num: slot_num)

      parking_system.park_on_slot(reg_no: reg_no,
                                  color: color,
                                  slot_num: slot_num)
    end
  end

  describe '#park_check' do
    let(:reg_no) { 'qwe' }
    let(:color) { 'blue' }

    context 'slot available' do
      it 'parks car' do
        slot_num = Random.rand(1..10)

        expect(parking_system).to receive(:park_on_slot)
          .with(reg_no: reg_no, color: color, slot_num: slot_num)

        expect(parking_system).to receive(:print_result)
          .with('Allocated slot number: ' + (slot_num + 1).to_s)

        parking_system.park_check(reg_no: reg_no,
                                  color: color,
                                  slot_num: slot_num)
      end
    end

    context 'slot unavailable' do
      it 'prints not found message' do
        expect(parking_system).to receive(:print_result)
          .with('Sorry, parking lot is full')

        parking_system.park_check(reg_no: reg_no,
                                  color: color,
                                  slot_num: nil)
      end
    end
  end

  describe '#file_mode' do
    it 'opens file and run program from file input' do
      file = StringIO.new "test1\ntest2\ntest3"
      path = 'dummy/path'

      allow(parking_system).to receive(:input_path).and_return(path)
      expect(File).to receive(:open).with(path, 'r')
                                    .and_return(file)
      expect(parking_system).to receive(:parse_user_input)
        .exactly(3).times

      parking_system.file_mode
    end
  end
end
