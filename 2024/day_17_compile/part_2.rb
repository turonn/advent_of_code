class Program
  attr_reader :outputs, :opcodes
  attr_accessor :reg_a
  def initialize(registers, opcodes)
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
    unless @opcodes[0...@outputs.size] == @outputs
      @halt = true
    end
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

a = 516964706 - 2

until program.outputs == program.opcodes
  a += 1
  program.run(a)
  trap("SIGINT") do
    puts "\nProgram interrupted. Latest progress: #{a}"
    exit
  end
end

pp "answer: #{a}"
pp program
