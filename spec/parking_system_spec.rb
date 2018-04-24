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
end
