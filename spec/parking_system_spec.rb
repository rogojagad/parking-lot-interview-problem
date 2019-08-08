# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ParkingSystem do
  let(:utilities) { instance_double Utilities }
  subject(:parking_system) { ParkingSystem.new utilities }

  describe '#initialize and attr_reader' do
    it 'has Utilities object as attribute' do
      parking_system = ParkingSystem.new utilities

      expect(parking_system.utilities).to eq(utilities)
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

    before do
      allow(parking_system).to receive(:input).and_return(input)
    end

    context 'one statement command' do
      it 'prints result in table format' do
        parking_lot = instance_double ParkingLot
        slots = %w[aaa www]

        allow(input).to receive(:split).and_return(['command1'])
        allow(parking_system).to receive(:parking_lot).and_return(parking_lot)
        allow(parking_lot).to receive(:slots).and_return(slots)

        expect(parking_system).to receive(:utilities).and_return(utilities)
        expect(utilities).to receive(:print_table).with(slots)
      end
    end

    context 'two statement command' do
      it 'calls two_statement_command parser function' do
        allow(input).to receive(:split).and_return(%w[command1 command2])

        expect(parking_system).to receive(:two_statement_command)
      end
    end

    context 'three statement command' do
      it 'calls three_statement_command parser function' do
        allow(input).to receive(:split)
          .and_return(%w[command1 command2 command3])

        expect(parking_system).to receive(:three_statement_command)
      end
    end

    after do
      parking_system.parse_user_input
    end
  end

  describe 'str_to_int' do
    before do
      expect(parking_system).to receive(:utilities).and_return(utilities)
    end

    context 'given string is convertable to int' do
      it 'returns int number' do
        expect(utilities).to receive(:to_int_or_nil).with('2').and_return(2)
        expect(parking_system.str_to_int('2')).to eq(2)
      end
    end

    context 'given string is not convertable' do
      it 'exit_execution' do
        expect(utilities).to receive(:to_int_or_nil).with('two').and_return(nil)
        expect(parking_system).to receive(:exit_execution)
        parking_system.str_to_int('two')
      end
    end
  end

  describe '#create_parking_lot' do
    it 'create new parking lot with given size' do
      input = 5
      parking_lot = instance_double ParkingLot
      allow(parking_system).to receive(:str_to_int).with(input.to_s)
                                                   .and_return(input)
      expect(ParkingLot).to receive(:new).with(input).and_return(parking_lot)

      parking_system.create_parking_lot(input.to_s)

      expect(parking_system.parking_lot).to eq(parking_lot)
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
    before do
      allow(parking_system).to receive(:str_to_int).with('5')
                                                   .and_return(5)
    end

    it 'runs leaving parking slot process properly' do
      expect(parking_system).to receive(:leave_park_slot).with(4)
      expect(parking_system).to receive(:utilities).and_return(utilities)
      expect(utilities).to receive(:print_result)
        .with('Slot number 5 is free')

      parking_system.leave_process '5'
    end
  end

  describe '#registration_numbers_by_color' do
    it 'retrieve reg_number of cars with corresponding color then compact_to_string' do
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

      expect(parking_system).to receive(:utilities).and_return(utilities)
      expect(utilities).to receive(:compact_to_string)
        .with(array)

      parking_system.registration_numbers_by_color color
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

      expect(parking_system).to receive(:utilities).and_return(utilities)
      expect(utilities).to receive(:compact_to_string)
        .with(array)

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
        expect(parking_lot).to receive(:get_slot_num_by_reg_no)
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

    before do
      expect(parking_system).to receive(:utilities).and_return(utilities)
    end

    context 'slot available' do
      it 'parks car' do
        slot_num = Random.rand(1..10)

        expect(parking_system).to receive(:park_on_slot)
          .with(reg_no: reg_no, color: color, slot_num: slot_num)

        expect(utilities).to receive(:print_result)
          .with('Allocated slot number: ' + (slot_num + 1).to_s)

        parking_system.park_check(reg_no: reg_no,
                                  color: color,
                                  slot_num: slot_num)
      end
    end

    context 'slot unavailable' do
      it 'prints not found message' do
        expect(utilities).to receive(:print_result)
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

  describe '#two_statement_command' do
    let(:size) { Random.rand(3..10) }
    let(:color) { 'blue' }
    let(:reg_number) { 'qwe123' }
    let(:slot_number) { Random.rand(3..10) }

    context 'will call print_result from utilities' do
      before do
        expect(parking_system).to receive(:utilities).and_return(utilities)
      end

      context 'create_parking_lot' do
        it 'creates parking lot instance' do
          input = ['create_parking_lot', size]

          expect(parking_system).to receive(:create_parking_lot).with(size)
          expect(utilities).to receive(:print_result)
            .with('Created a parking lot with ' + size.to_s + ' slots')

          parking_system.two_statement_command(input)
        end

        context '#registration_numbers_for_cars_with_colour' do
          it 'calls registration_numbers_by_colour' do
            result = reg_number
            input = ['registration_numbers_for_cars_with_colour', color]

            expect(parking_system).to receive(:registration_numbers_by_color)
              .with(color).and_return(result)
            expect(utilities).to receive(:print_result).with(result)

            parking_system.two_statement_command(input)
          end
        end

        context '#slot_numbers_for_cars_with_colour' do
          it 'calls slot_numbers_by_color' do
            result = slot_number
            input = ['slot_numbers_for_cars_with_colour', color]

            expect(parking_system).to receive(:slot_numbers_by_color)
              .with(color).and_return(result)
            expect(utilities).to receive(:print_result).with(result)

            parking_system.two_statement_command(input)
          end
        end

        context '#slot_number_for_registration_number' do
          it 'calls slot_num_by_registration_number' do
            result = slot_number

            input = ['slot_number_for_registration_number', reg_number]

            expect(parking_system).to receive(:slot_num_by_registration_number)
              .with(reg_number).and_return(result)
            expect(utilities).to receive(:print_result).with(result)

            parking_system.two_statement_command(input)
          end
        end
      end
    end

    context '#leave' do
      it 'empty slot with corresponding number' do
        num = 3
        input = ['leave', num]

        expect(parking_system).to receive(:leave_process).with(num)

        parking_system.two_statement_command(input)
      end
    end
  end

  describe '#three_statement_command' do
    it 'parses command with 3 components' do
      parking_lot = instance_double ParkingLot
      slot_num = Random.rand(1..10)
      input = %w[park qwe123 red]

      allow(parking_system).to receive(:parking_lot).and_return(parking_lot)
      allow(parking_lot).to receive(:available_slot).and_return(slot_num)

      expect(parking_system).to receive(:park_check)
        .with(reg_no: input[1], color: input[2], slot_num: slot_num)

      parking_system.three_statement_command input
    end
  end
end
