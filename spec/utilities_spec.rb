# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Utilities do
  subject(:utilities) { Utilities.new }

  describe '#print_result' do
    it 'prints given result to STDOUT' do
      output_str = 'output string'

      expect(STDOUT).to receive(:puts).with(output_str)

      utilities.print_result output_str
    end
  end

  describe '#receive_user_input' do
    it 'receive and return user input' do
      input_str = 'input string'

      allow(STDIN).to receive(:gets) { input_str }

      expect(utilities.receive_user_input).to eq(input_str)
    end
  end

  describe '#to_int_or_nil' do
    context 'string convertable to int number' do
      it 'return int number' do
        expect(utilities.to_int_or_nil('123')).to eq(123)
      end
    end

    context 'string unconvertable to int number' do
      it 'return nil' do
        expect(utilities.to_int_or_nil('one')).to eq(nil)
      end
    end
  end

  describe 'str_to_int' do
    context 'given string is convertable to int' do
      it 'returns int number' do
        expect(utilities).to receive(:to_int_or_nil).with('2').and_return(2)
        expect(utilities.str_to_int('2')).to eq(2)
      end
    end

    context 'given string is not convertable' do
      it 'exit_execution' do
        expect(utilities).to receive(:to_int_or_nil).with('two').and_return(nil)
        expect(utilities).to receive(:exit_execution)
        utilities.str_to_int('two')
      end
    end
  end

  describe '#compact_to_string' do
    it 'converts given array to proper string format' do
      array = %w[
        qwe
        asd
        zxc
        dfgert
      ]

      expected_string = 'qwe, asd, zxc, dfgert'

      result = utilities.compact_to_string(array)

      expect(result).to eq(expected_string)
    end
  end

  describe '#print_table' do
    let(:car1) { instance_double Car }
    let(:car2) { instance_double Car }

    let(:slots) { [car1, car2] }

    before do
      allow(car1).to receive(:reg_no).and_return('qwe')
      allow(car2).to receive(:reg_no).and_return('asd')

      allow(car1).to receive(:color).and_return('white')
      allow(car2).to receive(:color).and_return('black')
    end

    it 'prints array of Car object in proper string format' do
      table_format = "Slot No.    Registration No    Colour\n"

      slots.each_with_index do |slot, idx|
        next unless slot

        table_format += (idx + 1).to_s + '           ' + slot.reg_no + '      ' + slot.color
        table_format += "\n"
      end

      expect(utilities).to receive(:print_result).with(table_format)

      utilities.print_table(slots)
    end
  end
end

# print table
