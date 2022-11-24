file='2019/day_1/input.txt'
fuel_requirements = []

f = File.open(file, "r")
f.each_line do |line|
  single_fule_requirement = []
  mass = line.strip.to_i

  while mass.positive?
    fuel = (mass / 3).floor - 2

    single_fule_requirement << fuel if fuel.positive?
    mass = fuel
  end
  
  fuel_requirements << single_fule_requirement.sum
end

puts fuel_requirements.sum