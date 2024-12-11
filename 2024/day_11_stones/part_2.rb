class Stone
  attr_reader :num, :count
  def initialize(num, count)
    @num = num
    @count = count
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

    [Stone.new(first_num.to_i, @count), Stone.new(second_num.to_i, @count)]
  end

  def _multiply
    @num = @num * 2024
    [self]
  end
end

class Line
  def initialize(stones)
    @stones = stones
    _merge_stones
  end

  def blink
    @stones = @stones.flat_map(&:blink)
    _merge_stones
  end

  def count_stones
    @stones.sum(&:count)
  end

  private

  def _merge_stones
    @stones = @stones.group_by(&:num).map do |num, group|
      Stone.new(num, group.sum(&:count))
    end
  end
end


file = '2024/day_11_stones/input.txt'
f = File.open(file, "r")

line = nil
f.each_line do |l|
  line = Line.new(l.strip.split(' ').map { |num| Stone.new(num.to_i, 1) })
end

75.times do
  line.blink
end

pp line.count_stones
