file='2022/day_6/input.txt'
input = []
f = File.open(file, "r")
f.each_line do |line|
  input = line.strip.split('')
end

working_group = []
input.each_with_index do |v, i|
  working_group << v
  next if working_group.length < 14

  if working_group.uniq == working_group
    puts working_group
    puts i + 1
    return
  end

  working_group = working_group[1..-1]
end