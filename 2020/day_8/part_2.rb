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

def perform_action(instructions, line_number, accumulator)
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
  final_line = code_lines.size
  last_line_flipped = get_line_of_next_nop_or_jmp(code_lines, -1)
  code_lines = flip_line(code_lines, last_line_flipped)

  while true
    line = 0
    performed_lines = []
    accumulator = 0

    while performed_lines.uniq.length == performed_lines.length
      line, accumulator = perform_action(code_lines[line], line, accumulator)
      
      return accumulator if line == final_line

      performed_lines << line
    end
    code_lines, last_line_flipped = flip_next_line(code_lines, last_line_flipped)
  end
end

def flip_next_line(code_lines, last_line_flipped)
  code_lines = flip_line(code_lines, last_line_flipped)
  current_line_to_flip = get_line_of_next_nop_or_jmp(code_lines, last_line_flipped)
  
  code_lines = flip_line(code_lines, current_line_to_flip)
  [code_lines, current_line_to_flip]
end

def get_line_of_next_nop_or_jmp(code_lines, last_line_flipped)
  search_start = last_line_flipped + 1
  
  (search_start...code_lines.length).to_a.each do |line| 
    
    return line if code_lines[line][0] == "nop" || code_lines[line][0] == "jmp"
  end
  0
end

def flip_line(code_lines, line)
  instruction = code_lines[line]
  
  case instruction[0]
  when "nop"
    flipped_inst = "jmp"
  when "jmp"
    flipped_inst = "nop"
  else
    puts "something wrong on line #{line}"
  end

  code_lines[line] = [flipped_inst, instruction[1]]
  code_lines
end

puts get_accumulator(code_lines)