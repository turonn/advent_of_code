class FullRange
  attr_reader :ranges
  # @param ranges [Array<Range>]
  def initialize(ranges)
    @ranges = ranges
  end

  def collapse_ranges
    found_one = true

    # if the start is inside the range of another, merge the two ranges
    while found_one
      found_one = false

      @ranges.each do |range|
        overlapping_range = @ranges.detect do |other_range|
          next if range == other_range
          other_range.include?(range.start_num) || other_range.include?(range.end_num)
        end

        next if overlapping_range.nil?
        found_one = true

        new_start = [range.start_num, overlapping_range.start_num].min
        new_end = [range.end_num, overlapping_range.end_num].max
        new_range = Range.new(new_start, new_end)

        @ranges = @ranges.reject do |range|
          new_range.swallows?(range)
        end

        @ranges << new_range
        break
      end

      @ranges = @ranges.uniq
    end
  end

  def fresh_ids
    count = 0
    @ranges.each do |range|
      count += (range.end_num - range.start_num + 1)
    end

    count
  end
end

class Range
  attr_reader :start_num, :end_num
  def initialize(start_num, end_num)
    @start_num = start_num
    @end_num = end_num
  end

  # @param num [Integer]
  def include?(num)
    @start_num <= num && num <= @end_num
  end

  # @param other [Range]
  def swallows?(other)
    include?(other.start_num) && include?(other.end_num)
  end

  # @param other [Range]
  def ==(other)
    @start_num == other.start_num && @end_num == other.end_num
  end

  alias eql? ==
end

ranges = []
File.open('2025/day_5_fresh/input.txt', "r").each_line do |line|
  break if line.strip.empty?

  bounds = line.strip.split('-').map(&:to_i)
  ranges << Range.new(bounds[0], bounds[1])
end

full_range = FullRange.new(ranges)
full_range.collapse_ranges
puts full_range.fresh_ids
