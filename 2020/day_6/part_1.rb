file='2020/day_6/input.txt'
composite_answers = []
group_answers = []

f = File.open(file, "r")
f.each_line do |line|
  if line.strip.empty?
    answer = group_answers.group_by(&:itself)
    composite_answers << answer.count
    group_answers = []
  end
  arr = line.strip.split('')
  arr.each { |a| group_answers << a }
end

answer = group_answers.group_by(&:itself)
composite_answers << answer.count

puts composite_answers.inject(:+)