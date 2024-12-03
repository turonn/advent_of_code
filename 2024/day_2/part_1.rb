require_relative 'report'

file='2024/day_2/input.txt'

f = File.open(file, "r")
f.each_line do |line|
  levels = line.strip.split(' ').map(&:to_i)
  
  Report.new(levels)
end

count = 0

Report.all.each do |report|
  count += 1 if report.is_safe?
end

pp count