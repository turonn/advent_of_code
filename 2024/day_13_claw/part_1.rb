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
    @a_button = a_button
    @b_button = b_button
    @prize_location = prize_location
    @solutions = [] # [a_count, b_count]
  end

  def best_solution_cost
    costs = _solutions.flat_map { |solution| solution[0] * 3 + solution[1] }
    costs.min || 0
  end

  private

  def _solutions
    _find_solutions
    @solutions.uniq
  end

  # adds to the @solutions array
  def _find_solutions
    (0..100).each do |i|
      a_x_press = @a_button.x * i
      a_y_press = @a_button.y * i

      return if _larger_than_prize(a_x_press, a_y_press)

      (0..100).each do |j|
        b_x_press = @b_button.x * j
        b_y_press = @b_button.y * j

        break if _larger_than_prize(b_x_press, b_y_press)

        _add_if_solution(a_x_press + b_x_press, a_y_press + b_y_press, [i,j])
      end
    end
  end

  def _larger_than_prize(x, y)
    x > @prize_location[0] || y > @prize_location[1]
  end

  def _add_if_solution(x, y, solution)
    return unless x == @prize_location[0]
    return unless y == @prize_location[1]
    @solutions << solution
  end
end

machines = []
a_button = b_button = prize_location = nil

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
    prize_location = [arr[1].match(/\d+/)[0].to_i, arr[2].match(/\d+/)[0].to_i]

    machines << Machine.new(a_button, b_button, prize_location)
    a_button = b_button = prize_location = nil
  end
end

pp machines.map(&:best_solution_cost).sum