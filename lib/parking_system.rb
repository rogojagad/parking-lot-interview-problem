class ParkingSystem
  attr_accessor :parking_lot
  attr_reader :input

  def receive_user_input
    @input = STDIN.gets.strip
  end

  def print_result(output)
    puts output
  end
end
