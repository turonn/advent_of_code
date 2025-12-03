class Range
  def initialize(str)
    @start, @end = str.split('-').map(&:to_i)
  end

  def invalid_ids
    ids = []
    @start.upto(@end).each do |id|
      string = id.to_s
      length = string.length
      divisors = _divisors_minus_last(length)
      next if divisors.empty?

      divisors.each do |divisor|
        splits = length / divisor # how many times the string can be split by the divisor
        arr = 0.upto(splits - 1).map do |i|
          start = i * divisor
          finish = (i + 1) * divisor
          string[start...finish]
        end

        if arr.uniq.length == 1
          ids << id
        end
      end
    end

    ids.uniq
  end

  private

  def _divisors_minus_last(n)
    divisors = (1..n).select { |i| n % i == 0 }
    divisors[0..-2]
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
