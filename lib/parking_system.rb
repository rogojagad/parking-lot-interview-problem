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

  def create_parking_lot(splitted_input)
    size = to_num_or_nil(splitted_input[1])

    @parking_lot = ParkingLot.new(size)
  end

  def parse_user_input
    splitted_input = input.split
    if splitted_input.size == 1

    elsif splitted_input.size == 2
      if splitted_input[0] == 'create_parking_lot'
        create_parking_lot(splitted_input)
        size = splitted_input[1]
        print_result('Created a parking lot with ' + size + ' slots')
      elsif splitted_input[0] == 'leave'
        num_in_int = to_num_or_nil(splitted_input[1])
        leave_park_slot(num_in_int - 1)
        print_result('Slot number ' + splitted_input[1] + ' is free')
      elsif splitted_input[0] == 'registration_numbers_for_cars_with_colour'

      elsif splitted_input[0] == 'slot_numbers_for_cars_with_colour'

      elsif splitted_input[0] == 'slot_number_for_registration_number'

      end
    elsif splitted_input.size == 3
    end
  end

  def interactive_mode
    parse_user_input while receive_user_input
  end

  def run
    input_filename = ARGV[0]

    if input_filename
      file_mode
    else
      interactive_mode
    end
  end
end
