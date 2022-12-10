class Xvalue
  def initialize(signal_strength)
    @signal_strength = signal_strength
    @current_cycle = 0
    @map = [['#']]
    @current_row = 0
  end

  def execute_command(command)
    case command[0]
    when 'noop'
      @current_cycle += 1
    when 'addx'
      @current_cycle += 1
      _draw_pixel
      @current_cycle += 1
      @signal_strength += command[1].to_i
    end

    _draw_pixel
  end

  def print_map
    @map.each do |line|
      puts line.join('')
    end
  end

  private

  def _draw_pixel
    _move_down_row_if_needed

    if @current_cycle == @signal_strength || @current_cycle == (@signal_strength + 1) || @current_cycle == (@signal_strength - 1)
      @map[@current_row] << '#'
    else
      @map[@current_row] << '.'
    end
  end

  def _move_down_row_if_needed
    if @current_cycle % 40 == 0
      @current_row += 1
      @current_cycle = 0
      @map << []
    end
  end
end

def read_file(file)
  commands = []
  f = File.open(file, 'r')
  f.each_line do |line|
    commands << line.strip.split(' ')
  end
  commands
end

use_input = true
file = use_input ? '2022/day_10/input.txt' : '2022/day_10/example.txt'
commands = read_file(file)

x = Xvalue.new(1)
commands.each do |command|
  x.execute_command(command)
end

x.print_map
