file='2020/day_6/input.txt'
composite_answers = []
group_answers = []
members_in_group = 0

def count_shared_answers(group_answers, members_in_group)
  shared_answers = 0
  hash = group_answers.group_by(&:itself)
  hash.each do |k, v|
    if v.length >= members_in_group
      shared_answers += 1
    end
  end
  shared_answers
end

f = File.open(file, "r")
f.each_line do |line|
  if line.strip.empty?
    composite_answers << count_shared_answers(group_answers, members_in_group)
    group_answers = []
    members_in_group = 0
    next
  end
  arr = line.strip.split('')
  arr.each { |a| group_answers << a }
  members_in_group += 1
end

composite_answers << count_shared_answers(group_answers, members_in_group)

puts composite_answers.inject(:+)