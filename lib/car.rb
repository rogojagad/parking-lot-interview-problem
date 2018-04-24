class Car
  attr_reader :reg_no, :color

  def initialize(reg_no:, color:)
    @reg_no = reg_no
    @color = color
  end
end
