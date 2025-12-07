class Range
  def initialize(start_num, end_num)
    @start_num = start_num
    @end_num = end_num
  end

  def include?(num)
    num >= @start_num && num <= @end_num
  end
end

ranges = []
ids = []
phase = :range
File.open('2025/day_5_fresh/input.txt', "r").each_line do |line|
  if line.strip.empty?
    phase = :ids
    next
  end

  if phase == :range
    bounds = line.strip.split('-').map(&:to_i)
    ranges << Range.new(bounds[0], bounds[1])
  else
    ids << line.strip.to_i
  end
end

valid_ids = ids.select do |id|
  ranges.any? { |range| range.include?(id) }
end

puts valid_ids.count
