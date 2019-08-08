# frozen_string_literal: true

class Utilities
  def print_result(output)
    puts output
  end

  def receive_user_input
    STDIN.gets.strip
  end

  def to_int_or_nil(string)
    Integer(string || '')
  rescue ArgumentError
    nil
  end

  def compact_to_string(array)
    result_string = ''
    size = array.size

    array.each_with_index do |result, idx|
      result_string += result

      result_string += ', ' if idx != size - 1
    end

    result_string
  end

  def print_table(slots)
    table_format = "Slot No.\tRegistration No.\tColour"

    slots.each_with_index do |slot, idx|
      next unless slot

      table_format += (idx + 1).to_s + "\t\t" + slot.reg_no + "\t\t" + slot.color
      table_format += "\n"
    end

    print_result table_format
  end
end
