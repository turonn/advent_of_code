file='2019/day_1/input.txt'
fuel_requirements = []

f = File.open(file, "r")
f.each_line do |line|
  mass = line.strip.to_i
  fuel = (mass / 3).floor - 2

  fuel_requirements << fuel
end

puts fuel_requirements.sum