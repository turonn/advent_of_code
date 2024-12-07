class Integer
  def concat(other)
    (self.to_s + other.to_s).to_i
  end
end

class Equation
  module Operators
    ALL = Set.new([:+, :*, :concat]).freeze
  end

  attr_reader :answer

  def initialize(answer, nums)
    @answer = answer
    @nums = nums
  end

  def solvable?
    if @nums.count == 1
      return @nums.first == @answer
    end

    _possible_iterations.include?(@answer)
  end

  private

  # @return Array[Integer]
  def _possible_iterations
    accumulated_values = [@nums.first]

    @nums.each_with_index do |n, i|
      next if i == 0

      accumulated_values = accumulated_values.flat_map do |av|
        Operators::ALL.map { |op| av.send(op, n) }
      end
    end

    accumulated_values
  end
end

equations = []

file = '2024/day_7_bridge/input.txt'
f = File.open(file, "r")
f.each_line do |line|
  line = line.strip.split(':')
  answer = line.first.to_i
  nums = line[1].strip.split(' ').map(&:to_i)
  equations << Equation.new(answer, nums)
end

solvable = equations.select(&:solvable?)

pp solvable.sum(&:answer)