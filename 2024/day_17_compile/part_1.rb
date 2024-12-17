class Program
  attr_reader :outputs
  def initialize(registers, opcodes)
    @reg_a = registers[0]
    @reg_b = registers[1]
    @reg_c = registers[2]
    @opcodes = opcodes
    @instruction_pointer = 0
    @outputs = []
    @halt = false
    @should_advance = true
  end

  def run
    until @halt
      _advance
    end
    self
  end

  private

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
    pp __method__
    operand = _combo_operand
    return if @halt

    @reg_c = @reg_a / (2 ** operand)
  end

  def _bdv
    pp __method__

    operand = _combo_operand
    return if @halt

    @reg_b = @reg_a / (2 ** operand)
  end

  def _out
    pp __method__

    operand = _combo_operand
    return if @halt

    @outputs << operand % 8
  end

  def _bxc
    pp __method__

    operand = _literal_operand
    return if @halt

    @reg_b = @reg_b ^ @reg_c
  end

  def _jnz
    pp __method__

    return if @reg_a == 0

    operand = _literal_operand
    return if @halt

    return if operand == @instruction_pointer
    @instruction_pointer = operand

    @should_advance = false
  end

  def _bst
    pp __method__

    operand = _combo_operand
    return if @halt

    @reg_b = operand % 8
  end

  def _bxl
    pp __method__

    operand = _literal_operand
    return if @halt

    @reg_b = @reg_b ^ operand
  end

  def _adv
    pp __method__

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

pp program
pp program.run

pp program.run.outputs.join(',')
