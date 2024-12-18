class Program
  attr_reader :outputs, :opcodes
  attr_accessor :reg_a
  def initialize(registers, opcodes)
    @starting_a = registers[0]
    @reg_a = registers[0]
    @reg_b = registers[1]
    @reg_c = registers[2]
    @opcodes = opcodes
    _reset
  end

  def run(reg_a)
    @reg_a = reg_a
    @reg_b = @reg_c = 0
    _reset
    until @halt
      _advance
    end
    self
  end

  private

  def _reset
    @instruction_pointer = 0
    @outputs = []
    @halt = false
    @should_advance = true
  end

  def _advance
    if @instruction_pointer >= @opcodes.size
      @halt = true
      return
    end
    opcode = @opcodes[@instruction_pointer]

    case opcode
    when 0 then _adv
    when 1 then _bxl
    when 2 then _bst
    when 3 then _jnz
    when 4 then _bxc
    when 5 then _out
    when 6 then _bdv
    when 7 then _cdv
    end

    @instruction_pointer += 2 if @should_advance
    @should_advance = true
  end

  def _cdv
    operand = _combo_operand
    return if @halt

    @reg_c = @reg_a / (2 ** operand)
  end

  def _bdv
    operand = _combo_operand
    return if @halt

    @reg_b = @reg_a / (2 ** operand)
  end

  def _out
    operand = _combo_operand
    return if @halt

    @outputs << operand % 8
    # unless @opcodes[0...@outputs.size] == @outputs
    #   @halt = true
    # end
  end

  def _bxc
    operand = _literal_operand
    return if @halt

    @reg_b = @reg_b ^ @reg_c
  end

  def _jnz
    return if @reg_a == 0

    operand = _literal_operand
    return if @halt

    return if operand == @instruction_pointer
    @instruction_pointer = operand

    @should_advance = false
  end

  def _bst
    operand = _combo_operand
    return if @halt

    @reg_b = operand % 8
  end

  def _bxl
    operand = _literal_operand
    return if @halt

    @reg_b = @reg_b ^ operand
  end

  def _adv
    operand = _combo_operand
    return if @halt

    @reg_a = @reg_a / (2 ** operand)
  end

  # @return [Integer, nil]
  def _literal_operand
    operand_index = _operand_index
    return if @halt

    @opcodes[operand_index]
  end

  # @return [Integer, nil]
  def _combo_operand
    operand_index = _operand_index
    return if @halt

    case @opcodes[operand_index]
    when 0..3 then @opcodes[operand_index]
    when 4 then @reg_a
    when 5 then @reg_b
    when 6 then @reg_c
    when 7 then raise "can't do seven"
    end
  end

  # @return [Integer, nil]
  def _operand_index
    operand_index = @instruction_pointer + 1
    if operand_index >= @opcodes.size
      @halt = true
      return
    else
      operand_index
    end
  end
end

opcodes = []
registers = []

File.open('2024/day_17_compile/input.txt', "r").each_line do |line|
  arr = line.strip.split(' ')
  next if arr.empty?

  if arr[0] == "Register"
    registers << arr[-1].to_i
  else
    opcodes = arr[-1].split(',').map(&:to_i)
  end
end


program = Program.new(registers, opcodes)
# lower_bound = 8 ** (opcodes.count - 1)
# upper_bound = 190384119495695 # my solution was too high
# # upper_bound = 8 ** (opcodes.count)
# distance_betwen = upper_bound - lower_bound
# incrementer = if distance_betwen > 250000
#                 distance_betwen/250000
#               elsif distance_betwen > 100000
#                 distance_betwen/100000
#               elsif distance_betwen > 50000
#                 distance_betwen/50000
#               else
#                 1
#               end

# start = lower_bound
# finish = upper_bound

# index_from_end = -1 
# first = nil

# until -index_from_end == program.opcodes.count
#   i = 0
#   a = lower_bound
#   while a <= upper_bound
#     program.run(a)

#     if program.outputs[index_from_end..-1] == program.opcodes[index_from_end..-1]
#       first ||= a
#       last = a
#       if program.outputs == program.opcodes
#         pp "xxxxxxxxxxxxxxxxxxxxx"
#         pp "we're here! #{a}"
#         pp "xxxxxxxxxxxxxxxxxxxxx"
#         return
#       end
#     end

#     a += incrementer
#   end

#   first ||= lower_bound
#   lower_bound = first - (incrementer * 2)
#   upper_bound = last + incrementer
#   distance_betwen = upper_bound - lower_bound
#   incrementer = if -index_from_end == program.opcodes.count - 1
#                   pp "last one!"
#                   1
#                 elsif distance_betwen > 250000
#                   distance_betwen/250000
#                 elsif distance_betwen > 100000
#                   distance_betwen/100000
#                 elsif distance_betwen > 50000
#                   distance_betwen/50000
#                 else
#                   1
#                 end

#   pp "matched so far: #{-index_from_end}"
#   pp "lower #{lower_bound}"
#   pp "upper #{upper_bound}"
#   pp "incrementer #{incrementer}"

#   index_from_end -= 1
#   first = nil
# end


# old_start = 190384113204656
# old_finish = 190384172514368
# old_incrementer = (old_finish - old_start)/100000

# start = 190384114056203
# finish = 190384119823721
# pp finish - start

# incrementer = (finish - start)/100000
# # little buffer
# a = start - old_incrementer
# f = finish + old_incrementer

# first = nil
# last = nil
a = 190384113269148
inc = 1
attempt = nil
until program.outputs == program.opcodes
  a -= inc
  program.run(a)

  if program.outputs == program.opcodes
    pp "answer: #{a}"
    break
  end

  inc += 1

  trap("SIGINT") do
    puts "\nProgram interrupted. Latest progress: #{a}"
    exit
  end
end

# pp "First - #{first}"
# pp "Last - #{last}"

# pp program
# pp "answer: #{attempt}" if program.outputs == opcodes
# last checked: 3698099872
# 190384119495695 is too high

# Key insights!
# 1 - a new outputted each power of 8
# 16 outputs 35184372088832..281474976710656
# 0 between 175922212275410 and 211104825142520
# 0,3 between 189116043778388 and 211106232256772
# 0,3,5 betwen 190215641176028 and 208357326704144
# 0,3,5,5 between 190353116667089 and 208013684667629
# 0,3,5,5,7 between 190378896285194 and 207979418353994
# 0,3,5,5,7,1 between 190384175841334 and 207977305622094
# last 7 between 190384175767411 and 190627488751162
# last 8 between 190384106893790 and 190384172588273
# last 9 between 190384112140453 and 190384172957557
# last 10 between 190384113189205 and 190384172695381
# last 11 between 190384113189192 and 190384172695142
# last 12 between 190384113201687 and 190384172695142
# last 13 between 190384113204656 and 190384172514368
# last 14 between 190384114056203 and 190384119823721
# last 15 around 190384119495690