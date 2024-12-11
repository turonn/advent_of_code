class Stone
  attr_reader :size
  def initialize(num)
    @num = num
  end

  def blink
    _zero ||
      _even_digits ||
      _multiply
  end

  private

  def _zero
    return false unless @num == 0
    @num = 1
    [self]
  end

  def _even_digits
    num_str = @num.to_s
    num_str_size = num_str.size
    return false unless num_str_size.even?

    mid = num_str_size / 2
    first_num = num_str[0...mid]
    second_num = num_str[mid..-1]

    [Stone.new(first_num.to_i), Stone.new(second_num.to_i)]
  end

  def _multiply
    @num = @num * 2024
    [self]
  end
end

class Line
  def initialize(stones)
    @stones = stones
  end

  def blink
    @stones = @stones.flat_map(&:blink)
  end

  def count_stones
    @stones.count
  end
end


file = '2024/day_11_stones/input.txt'
f = File.open(file, "r")

line = nil
f.each_line do |l|
  line = Line.new(l.strip.split(' ').map { |num| Stone.new(num.to_i) })
end

25.times do
  line.blink
end

pp line.count_stones