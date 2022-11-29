file='2019/day_2/input.txt'
initial_memory = []
solution = 19690720

f = File.open(file, "r")
f.each_line do |line|
  initial_memory = line.strip.split(',').map(&:to_i)
end

def get_new_noun_and_verb(noun, verb)
  noun += 1
  if noun > 99
    noun -= 100
    verb += 1
  end
  
  [noun, verb]
end

def new_setup(memory, noun, verb)
  memory[1] = noun
  memory[2] = verb
  memory
end

# @param working_memory [Array[Integer]]
# @return [Array[Integer]]
def run(working_memory)
  index = 0
  opcode = working_memory[0]
  new_index = working_memory[index + 3]
  new_two = working_memory[index + 2]
  new_one = working_memory[index + 1]

  while opcode != 99
    case opcode
    when 1
      working_memory[new_index] = working_memory[new_one] + working_memory[new_two]
    when 2
      working_memory[new_index] = working_memory[new_one] * working_memory[new_two]
    when 99
      break
    else
      break "error at index #{index}"
    end

    index = index + 4
    break if index > (working_memory.length - 4)

    new_index = working_memory[index + 3]
    new_two = working_memory[index + 2]
    new_one = working_memory[index + 1]
    opcode = working_memory[index]
  end

  working_memory
end

def find_solution(noun, verb, initial_memory, solution)
  while true
    memory = initial_memory.dup
    noun, verb = get_new_noun_and_verb(noun, verb)
    working_memory = new_setup(memory, noun, verb)
    output = run(working_memory)[0]
    break if output == solution
  end

  [noun, verb]
end


noun, verb = find_solution(-1, 0, initial_memory, solution)

puts noun
puts verb
puts "x"
puts (100 * noun + verb)