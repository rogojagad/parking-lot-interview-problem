# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Car do
  let(:reg_no) { 'ASD 123 HH' }
  let(:color) { 'White' }
  subject(:car) { Car.new(reg_no: reg_no, color: color) }

  it 'has proper attribute value' do
    expect(car.reg_no).to eq(reg_no)
    expect(car.color).to eq(color)
  end
end
