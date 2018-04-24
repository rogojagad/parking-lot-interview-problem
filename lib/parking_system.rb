class ParkingSystem
  attr_accessor :parking_lot
  attr_reader :input

  def receive_user_input
    @input = STDIN.gets.strip
  end

  def leave_park_slot(slot_num)
    parking_lot.leave slot_num
  end

  def print_result(output)
    puts output
  end

  def to_num_or_nil(string)
    Integer(string || '')
  rescue ArgumentError
    nil
  end

  def compact_to_string(size, array)
    result_string = ''

    array.each_with_index do |result, idx|
      result_string += result

      result_string += ', ' if idx != size - 1
    end

    result_string
  end

  def create_parking_lot(splitted_input)
    size = to_num_or_nil(splitted_input[1])
    exit_execution unless size
    @parking_lot = ParkingLot.new(size)
  end

  def registration_numbers_by_color(color)
    results = parking_lot.get_reg_numbers_by_color(color)

    size = results.size

    compact_to_string(size, results)
  end

  def slot_numbers_by_color(color)
    result = parking_lot.get_slot_num_by_color color
    size = result.size
    compact_to_string(size, result)
  end

  def slot_num_by_registration_number(reg_no)
    slot_num = parking_lot.get_slot_num_by_reg_no(reg_no)
    return 'Not found' unless slot_num
    slot_num.to_s
  end

  def print_table
    parking_slots = parking_lot.slots
    puts "Slot No.\tRegistration No.\tColour"
    parking_slots.each_with_index do |slot, idx|
      next unless slot
      output = (idx + 1).to_s + "\t\t" + slot.reg_no + "\t\t" + slot.color
      puts output
    end
  end

  def park_on_slot(reg_no:, color:, slot_num:)
    car = Car.new(reg_no: reg_no, color: color)
    parking_lot.park(car: car, slot_num: slot_num)
  end

  def park_check(reg_no:, color:, slot_num:)
    if slot_num
      park_on_slot(reg_no: reg_no, color: color, slot_num: slot_num)
      print_result 'Allocated slot number: ' + (slot_num + 1).to_s
    else
      print_result 'Sorry, parking lot is full'
    end
  end

  def parse_user_input
    splitted_input = input.split
    if splitted_input.size == 1
      print_table
    elsif splitted_input.size == 2
      if splitted_input[0] == 'create_parking_lot'
        create_parking_lot(splitted_input)
        size = splitted_input[1]
        print_result('Created a parking lot with ' + size + ' slots')
      elsif splitted_input[0] == 'leave'
        num_in_int = to_num_or_nil(splitted_input[1])
        exit_execution unless num_in_int
        leave_park_slot(num_in_int - 1)
        print_result('Slot number ' + splitted_input[1] + ' is free')
      elsif splitted_input[0] == 'registration_numbers_for_cars_with_colour'
        result = registration_numbers_by_color(splitted_input[1])
        print_result result
      elsif splitted_input[0] == 'slot_numbers_for_cars_with_colour'
        result = slot_numbers_by_color(splitted_input[1])
        print_result result
      elsif splitted_input[0] == 'slot_number_for_registration_number'
        result = slot_num_by_registration_number(splitted_input[1])
        print_result result
      end
    elsif splitted_input.size == 3
      slot_num = parking_lot.available_slot
      park_check(reg_no: splitted_input[1],
                 color: splitted_input[2],
                 slot_num: slot_num)
    end
  end

  def interactive_mode
    parse_user_input while receive_user_input
  end

  def file_mode; end

  def run
    input_filename = ARGV[0]

    if input_filename
      file_mode
    else
      interactive_mode
    end
  end

  private

  def exit_execution
    print_result 'Argument type error, check again'
    exit 1
  end
end
