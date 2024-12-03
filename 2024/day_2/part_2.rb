require_relative 'report_2'

file = '2024/day_2/input.txt'

f = File.open(file, "r")
f.each_line do |line|
  levels = line.strip.split(' ').map(&:to_i)
  
  Report.new(levels, true)
end

count = 0

Report.all.each do |report|
  count += 1 if report.is_safe? || report.safe_with_dampener?
end

pp count