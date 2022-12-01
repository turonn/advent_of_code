file='2022/day_1/input.txt'
elves = []
single_elf = []

f = File.open(file, "r")
f.each_line do |line|
  cals = line.strip.to_i
  if cals == 0
    elves << single_elf
    single_elf = []
    next
  end

  single_elf << cals
end

elves << single_elf

puts elves.map(&:sum).sort.reverse.take(3).sum
