file='2020/day_8/input.txt'
code_lines = {}
accumulator = 0

line_number = 0
f = File.open(file, "r")
f.each_line do |line|
  instructions = line.strip.split(' ')
  instructions[1] = [instructions[1][0], instructions[1][1..-1]]

  code_lines[line_number] = instructions
  line_number += 1
end

def add_number_and_sym(num, arr)
  if arr[0] == "+"
    num + arr[1].to_i
  else
    num - arr[1].to_i
  end
end

def perform_next_action(instructions, line_number, accumulator)
  case instructions[0]
  when "nop"
    [(line_number + 1), accumulator]
  when "acc"
    [(line_number + 1), add_number_and_sym(accumulator, instructions[1])]
  when "jmp"
    [add_number_and_sym(line_number, instructions[1]), accumulator]
  else
    puts "oops on #{instructions}"
  end
end

def accumulator_or_new_performed_lines(performed_lines, new_line, accumulator)
  if performed_lines.include?(new_line)
    accumulator
  else
    performed_lines << new_line
  end
end

def get_accumulator(code_lines)
  line = 0
  performed_lines = [0]
  accumulator = 0

  while performed_lines.kind_of?(Array)
    line, accumulator = perform_next_action(code_lines[line], line, accumulator)
    performed_lines = accumulator_or_new_performed_lines(performed_lines, line, accumulator)
  end
  performed_lines
end

puts get_accumulator(code_lines)