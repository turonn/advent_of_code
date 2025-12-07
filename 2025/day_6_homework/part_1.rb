class Problem
  attr_reader :index, :answer
  # @param index [Integer]
  def initialize(index)
    @index = index
    @operands = []
    @operation = nil
    @answer = nil
  end

  # @param operand [Integer]
  def add_operand(operand)
    @operands << operand
  end

  # @param operation [Symbol] :+, :*
  def set_operation(operation)
    @operation = operation
  end

  def solve
    @answer = @operands.reduce(@operation)
  end
end

class Solver
  def initialize
    @problems = []
    @answer = 0
  end

  # @return [Integer]
  def solve
    @problems.each do |problem|
      @answer += problem.answer
    end
    @answer
  end

  # @param index [Integer]
  # @param value [String]
  def add_or_contribute(index, value)
    problem = _find_or_add_problem(index)

    if ['+', '*'].include?(value)
      problem.set_operation(value.to_sym)
      problem.solve
    else
      problem.add_operand(value.to_i)
    end
  end

  # @param index [Integer]
  # @return [Problem]
  def _find_or_add_problem(index)
    problem = @problems.detect { |p| p.index == index }
    return problem if problem

    problem = Problem.new(index)
    @problems << problem
    problem
  end
end

solver = Solver.new
File.open('2025/day_6_homework/input.txt', "r").each_line do |line|
  line = line.strip.split('')

  problem_index = 0
  value_arr = []
  line.each do |char|
    # skip this character if we're in between values
    if char == ' ' && value_arr.empty?
      next
    end

    # this is the first white space after a value
    if char == ' '
      solver.add_or_contribute(problem_index, value_arr.join(''))
      problem_index += 1
      value_arr = []
      next
    end

    value_arr << char
  end

  # take into account the last value in the line
  solver.add_or_contribute(problem_index, value_arr.join(''))
end

puts solver.solve
