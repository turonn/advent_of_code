class Range
  def initialize(str)
    @start, @end = str.split('-').map(&:to_i)
  end

  def invalid_ids
    ids = []
    @start.upto(@end).each do |id|
      string = id.to_s
      length = string.length
      next unless length.even?

      first_half = string[0, length / 2]
      second_half = string[length / 2, length / 2]
      if first_half == second_half
        ids << id
      end
    end

    ids
  end
end

ranges = []
File.open('2025/day_2/input.txt', "r").each_line do |line|
  string_ranges = line.strip.split(',')
  ranges = string_ranges.map { |r| Range.new(r) }
end

invalid_ids = []
ranges.each do |range|
  invalid_ids = invalid_ids + range.invalid_ids
end

puts invalid_ids.sum
