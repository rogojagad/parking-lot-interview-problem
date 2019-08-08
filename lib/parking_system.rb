# frozen_string_literal: true

class ParkingSystem
  attr_reader :input_path, :parking_lot, :utilities

  def initialize(utilities)
    @utilities = utilities
  end

  def leave_park_slot(slot_num)
    parking_lot.leave slot_num
  end

  def str_to_int(num_in_str)
    num_in_int = utilities.to_int_or_nil(num_in_str)
    exit_execution unless num_in_int
    num_in_int
  end

  def create_parking_lot(size_in_str)
    size_in_int = str_to_int(size_in_str)
    @parking_lot = ParkingLot.new(size_in_int)
  end

  def registration_numbers_by_color(color)
    results = parking_lot.get_reg_numbers_by_color(color)

    size = results.size

    utilities.compact_to_string(results)
  end

  def slot_numbers_by_color(color)
    result = parking_lot.get_slot_num_by_color color
    size = result.size
    utilities.compact_to_string(result)
  end

  def slot_num_by_registration_number(reg_no)
    slot_num = parking_lot.get_slot_num_by_reg_no(reg_no)
    return 'Not found' unless slot_num

    slot_num.to_s
  end

  def park_on_slot(reg_no:, color:, slot_num:)
    car = Car.new(reg_no: reg_no, color: color)
    parking_lot.park(car: car, slot_num: slot_num)
  end

  def park_process(reg_no:, color:, slot_num:)
    park_on_slot(reg_no: reg_no, color: color, slot_num: slot_num)
    utilities.print_result 'Allocated slot number: ' + (slot_num + 1).to_s
  end

  def leave_process(num_in_str)
    num_in_int = str_to_int(num_in_str)
    leave_park_slot(num_in_int - 1)
    utilities.print_result 'Slot number ' + num_in_str + ' is free'
  end

  def two_statement_command(splitted_input)
    if splitted_input[0] == 'create_parking_lot'
      size = splitted_input[1]
      create_parking_lot(size)
      utilities.print_result('Created a parking lot with ' + size.to_s + ' slots')
    elsif splitted_input[0] == 'leave'
      leave_process(splitted_input[1])
    elsif splitted_input[0] == 'registration_numbers_for_cars_with_colour'
      result = registration_numbers_by_color(splitted_input[1])
      utilities.print_result result
    elsif splitted_input[0] == 'slot_numbers_for_cars_with_colour'
      result = slot_numbers_by_color(splitted_input[1])
      utilities.print_result result
    elsif splitted_input[0] == 'slot_number_for_registration_number'
      result = slot_num_by_registration_number(splitted_input[1])
      utilities.print_result result
    end
  end

  def check_and_park(splitted_input)
    slot_num = parking_lot.available_slot

    if slot_num
      park_process(reg_no: splitted_input[1],
                   color: splitted_input[2],
                   slot_num: slot_num)
    else
      utilities.print_result 'Sorry, parking lot is full'
    end
  end

  def parse_user_input(input)
    splitted_input = input.split
    if splitted_input.size == 1
      utilities.print_table parking_lot.slots
    elsif splitted_input.size == 2
      two_statement_command splitted_input
    elsif splitted_input.size == 3
      check_and_park splitted_input
    end
  end

  def interactive_mode
    loop do
      parse_user_input utilities.receive_user_input
    end
  end

  def file_mode
    input_file = File.open(input_path, 'r')

    input_file.each_line do |line|
      parse_user_input line
    end
  end

  def run
    input_filename = ARGV[0]

    if input_filename
      set_input_path input_filename
      file_mode
    else
      interactive_mode
    end
  end

  private

  def exit_execution
    utilities.print_result 'Argument is not integer, check again'
    exit 1
  end

  def set_input_path(filename)
    @input_path = filename
    # puts @input_path
  end
end
