file='2019/day_2/input.txt'
input_code = []

f = File.open(file, "r")
f.each_line do |line|
  input_code = line.strip.split(',').map(&:to_i)
end

index = 0
opcode = input_code[0]
new_index = input_code[index + 3]
new_two = input_code[index + 2]
new_one = input_code[index + 1]

while opcode != 99
  case opcode
  when 1
    input_code[new_index] = input_code[new_one] + input_code[new_two]
  when 2
    input_code[new_index] = input_code[new_one] * input_code[new_two]
  when 99
    break
  else
    break "error at index #{index}"
  end

  index += 4
  break if index > input_code.length - 4

  new_index = input_code[index + 3]
  new_two = input_code[index + 2]
  new_one = input_code[index + 1]

  opcode = input_code[index]
end

puts input_code[0]