file = '2022/day_3/input.txt'
group = []
security_badges = []
elves_in_group = 0

f = File.open(file, 'r')
f.each_line do |line|
  sack = line.strip.split('').uniq
  group << sack
  elves_in_group += 1
  
  if elves_in_group > 2
    security_badges += (group[0] & group[1] & group[2])
    group = []
    elves_in_group = 0
  end
end

asciis = security_badges.map(&:ord)

priorities = asciis.map do |ascii|
  if ascii < 91
    ascii - 64 + 26 # captital
  else
    ascii - 96 # lowercase
  end
end

puts priorities.sum
