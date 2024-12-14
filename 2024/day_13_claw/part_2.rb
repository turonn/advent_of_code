require 'matrix'

class Button
  attr_reader :x, :y, :cost
  def initialize(x, y, cost)
    @x = x
    @y = y
    @cost = cost
  end
end

class Machine
  # @param prize_location [Array<Integer>] [x,y]
  def initialize(a_button, b_button, prize_location)
    @button_matrix = Matrix[
      [a_button.x, b_button.x],
      [a_button.y, b_button.y]
    ]

    @prize_matrix = Matrix[[prize_location[0]],[prize_location[1]]]
  end

  def best_solution_cost
    solution = _solution
    return 0 if solution.empty?

    solution[0] * 3 + solution[1]
  end

  private

  def _solution
    solution = (@button_matrix.inverse * @prize_matrix).column(0).to_a
    solution.all? { |s| s.denominator == 1 } ? solution : []
   end
end

machines = []
a_button = b_button = prize_location = nil
LOTS = 10_000_000_000_000

file = '2024/day_13_claw/input.txt'
f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split(' ')
  next if arr.empty?

  case arr[0]
  when "Button"
    # Button A: X+94, Y+34
    if arr[1] == "A:"
      a_button = Button.new(arr[2].match(/\d+/)[0].to_i, arr[3].match(/\d+/)[0].to_i, 3)
    else
      b_button = Button.new(arr[2].match(/\d+/)[0].to_i, arr[3].match(/\d+/)[0].to_i, 1)
    end
  when "Prize:"
    prize_location = [arr[1].match(/\d+/)[0].to_i + LOTS, arr[2].match(/\d+/)[0].to_i + LOTS]

    machines << Machine.new(a_button, b_button, prize_location)
    a_button = b_button = prize_location = nil
  end
end

pp machines.map(&:best_solution_cost).sum