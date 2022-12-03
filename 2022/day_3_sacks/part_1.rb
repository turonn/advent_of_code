file = '2022/day_3/input.txt'
number_of_lines = 0
sacks = []

f = File.open(file, 'r')
f.each_line do |line|
  sack = line.strip.split('')
  compartment_1 = sack.first(sack.count / 2)
  compartment_2 = sack.last(sack.count / 2)

  asciis = (compartment_1 & compartment_2).map(&:ord)

  priorities = asciis.map do |ascii|
    if ascii < 91
      ascii - 64 + 26 # captital
    else
      ascii - 96 # lowercase
    end
  end

  sacks += priorities

end

puts sacks.sum
