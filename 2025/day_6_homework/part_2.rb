

class Problem
  attr_reader :answer
  # each array is a column of values
  # @param values [Array<Array<String>>]
  def initialize(value_arrays)
    _set_operation(value_arrays)

    # take off the operation symbol row from each column
    _set_operands(value_arrays.map { |arr| arr[0..-2] })
    _solve_problem
  end

  private

  # @param values [Array<Array<String>>]
  def _set_operation(values)
    values.each do |array|
      if array.include?('+')
        @operation = :+
        return
      elsif array.include?('*')
        @operation = :*
        return
      end
    end
  end

  # @param value_arrays [Array<Array<String>>] eg [[' ','2','3'],['4','5','6']]
  def _set_operands(value_arrays)
    @operands = []
    value_arrays.each do |value_array|
      @operands << value_array.join('').strip.to_i
    end
  end

  def _solve_problem
    @answer = @operands.reduce(@operation)
  end
end

class Solver
  # @param rows [Array<String>]
  def initialize(rows)
    @rows = rows
    @max_length = rows.map(&:length).max
    @problems = []
  end

  def fill_rows
    new_rows = []
    @rows.each do |row|
      r = row.dup
      while r.length < @max_length
        r << ' '
      end
      new_rows << r
    end
    @rows = new_rows
  end

  def create_problems
    working_problem_vals = []
    0.upto(@max_length - 1) do |col_index|
      vals = @rows.map { |row| row[col_index] }

      # done with this problem
      if vals.all? { |v| v == ' ' }
        @problems << Problem.new(working_problem_vals)
        working_problem_vals = []
        next
      end

      working_problem_vals << vals
    end

    @problems << Problem.new(working_problem_vals)
  end

  def solve
    @problems.sum { |p| p.answer }
  end
end

rows = []
File.open('2025/day_6_homework/input.txt', "r").each_line do |line|
  rows << line.split('').reject { |c| c == "\n" }
end
solver = Solver.new(rows)

solver.fill_rows
solver.create_problems
puts solver.solve
