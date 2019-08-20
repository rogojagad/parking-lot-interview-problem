# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ParkingSystem do
  let(:utilities) { instance_double Utilities }
  let(:command_to_func_hash) do
    { create_parking_lot: parking_system.method(:create_parking_lot),
      leave: parking_system.method(:leave_process),
      registration_numbers_for_cars_with_colour: parking_system.method(:registration_numbers_by_color),
      slot_numbers_for_cars_with_colour: parking_system.method(:slot_numbers_by_color),
      slot_number_for_registration_number: parking_system.method(:slot_num_by_registration_number) }
  end

  subject(:parking_system) { ParkingSystem.new utilities }

  describe '#initialize and attr_reader' do
    it 'has Utilities object as attribute' do
      expect(parking_system.utilities).to eq(utilities)
    end

    it 'has proper command_to_func_hash attribute' do
      expect(parking_system.command_to_func_hash).to eq(command_to_func_hash)
    end
  end

  describe '#run' do
    context 'system argument given' do
      it 'runs in file mode' do
        ARGV.replace ['filename']
        expect(parking_system).to receive(:set_input_path).with('filename')
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

  describe '#parse_user_input' do
    let(:input) { double }

    context 'one statement command' do
      it 'prints report in table format' do
        parking_lot = instance_double ParkingLot
        slots = %w[aaa www]

        allow(input).to receive(:split).and_return(['command1'])
        allow(parking_system).to receive(:parking_lot).and_return(parking_lot)
        allow(parking_lot).to receive(:slots).and_return(slots)

        allow(parking_system).to receive(:utilities).and_return(utilities)
        expect(utilities).to receive(:print_table).with(slots)
      end
    end

    context 'two statement command' do
      it 'calls two_statement_command parser function' do
        allow(input).to receive(:split).and_return(%w[command1 command2])

        expect(parking_system).to receive(:two_statement_command)
          .with(%w[command1 command2])
      end
    end

    context 'three statement command' do
      it 'calls park_process parser function' do
        allow(input).to receive(:split)
          .and_return(%w[command1 command2 command3])

        expect(parking_system).to receive(:check_and_park)
          .with(%w[command1 command2 command3])
      end
    end

    after do
      parking_system.parse_user_input input
    end
  end

  describe '#create_parking_lot' do
    it 'create new parking lot with given size' do
      input = Random.rand(1..10)
      parking_lot = instance_double ParkingLot

      allow(parking_system).to receive(:utilities).and_return(utilities)

      expect(utilities).to receive(:str_to_int).with(input.to_s)
                                               .and_return(input)
      expect(ParkingLot).to receive(:new).with(input).and_return(parking_lot)
      expect(utilities).to receive(:print_result)
        .with('Created a parking lot with ' + input.to_s + ' slots')

      parking_system.create_parking_lot(input.to_s)
    end
  end

  describe '#leave_park_slot' do
    it 'empties the corresponding slot' do
      parking_lot = instance_double ParkingLot
      slot_num = Random.rand(1..10)

      allow(parking_system).to receive(:parking_lot)
        .and_return(parking_lot)
      expect(parking_lot).to receive(:leave).with(slot_num)

      parking_system.leave_park_slot(slot_num)
    end
  end

  describe '#leave_process' do
    it 'runs leaving parking slot process properly' do
      allow(parking_system).to receive(:utilities).and_return(utilities)
      expect(utilities).to receive(:str_to_int).with('5').and_return(5)
      expect(parking_system).to receive(:leave_park_slot).with(4)
      expect(utilities).to receive(:print_result)
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
      expected_string = 'b 1234 a, c 2345 b, d 3456 d'

      parking_lot = double
      color = 'white'

      allow(parking_system).to receive(:parking_lot)
        .and_return(parking_lot)
      expect(parking_lot).to receive(:get_reg_numbers_by_color)
        .with(color)
        .and_return(array)

      allow(parking_system).to receive(:utilities).and_return(utilities)
      expect(utilities).to receive(:compact_to_string)
        .with(array)
        .and_return(expected_string)

      expect(utilities).to receive(:print_result)
        .with(expected_string)

      parking_system.registration_numbers_by_color color
    end
  end

  describe '#slot_numbers_by_color' do
    it 'retrieve slot number of cars with corresponding color' do
      array = [1, 3, 4]
      parking_lot = double
      color = 'white'
      expected_string = '1, 3, 4'

      allow(parking_system).to receive(:parking_lot)
        .and_return(parking_lot)
      allow(parking_system).to receive(:utilities).and_return(utilities)

      expect(parking_lot).to receive(:get_slot_num_by_color)
        .with(color)
        .and_return(array)

      expect(utilities).to receive(:compact_to_string)
        .with(array)
        .and_return(expected_string)

      expect(utilities).to receive(:print_result).with(expected_string)

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
        allow(parking_system).to receive(:utilities)
          .and_return(utilities)

        expect(parking_lot).to receive(:get_slot_num_by_reg_no)
          .with(reg_no)
          .and_return(slot_num)

        expect(utilities).to receive(:print_result)
          .with(slot_num.to_s)

        parking_system.slot_num_by_registration_number(reg_no)
      end
    end

    context 'registration number not exist' do
      it 'returns not found string' do
        allow(parking_system).to receive(:parking_lot)
          .and_return(parking_lot)
        expect(parking_lot).to receive(:get_slot_num_by_reg_no)
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

  describe '#check_and_park' do
    let(:reg_no) { 'qwe' }
    let(:color) { 'blue' }
    let(:slot_num) { slot_num = Random.rand(1..10) }
    let(:parking_lot) { instance_double ParkingLot }

    before do
      allow(parking_system).to receive(:parking_lot).and_return(parking_lot)
    end

    context 'slot available' do
      it 'calls park process' do
        allow(parking_lot).to receive(:available_slot).and_return(slot_num)

        expect(parking_system).to receive(:park_process).with(reg_no: reg_no,
                                                              color: color,
                                                              slot_num: slot_num)
      end
    end

    context 'slot unavailable' do
      it 'calls print_result with prints not found message' do
        allow(parking_lot).to receive(:available_slot).and_return(nil)
        allow(parking_system).to receive(:utilities).and_return(utilities)

        expect(utilities).to receive(:print_result)
          .with('Sorry, parking lot is full')
      end
    end

    after do
      parking_system.check_and_park(['park', reg_no, color])
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

  describe '#two_statement_command' do
    let(:size) { Random.rand(3..10) }

    it 'calls proper function based on given command' do
      input = ['create_parking_lot', size]

      allow(parking_system).to receive(:command_to_func_hash)
        .and_return(command_to_func_hash)

      expect(command_to_func_hash[input[0].to_sym])
        .to receive(:call).with(input[1])

      parking_system.two_statement_command(input)
    end
  end

  describe '#park_process' do
    it 'parks a car and print allocated slot number' do
      reg_no = 'asd'
      color = 'maroon'
      slot_num = Random.rand(1..10)

      expect(parking_system).to receive(:park_on_slot).with(
        reg_no: reg_no,
        color: color,
        slot_num: slot_num
      )

      allow(parking_system).to receive(:utilities).and_return(utilities)

      expect(utilities).to receive(:print_result)
        .with('Allocated slot number: ' + (slot_num + 1).to_s)

      parking_system.park_process(reg_no: reg_no,
                                  color: color,
                                  slot_num: slot_num)
    end
  end
end
