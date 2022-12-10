class Xvalue
  attr_accessor :signal_strength, :signal_during_multiple_of_fourty, :past_multiples_of_fourty, :current_cycle, :next_multiple_of_fourty

  def initialize(signal_strength)
    @signal_strength = signal_strength
    @signal_during_multiple_of_fourty = []
    @past_multiples_of_fourty = []
    @current_cycle = 0
    @next_multiple_of_fourty = 19
  end

  def execute_command(command)
    case command[0]
    when "noop"
      @current_cycle += 1
    when "addx"
      @current_cycle += 1
      _consider_multiple_of_fourty
      @current_cycle += 1
      @signal_strength += command[1].to_i
    end

    _consider_multiple_of_fourty
  end

  def score
    score = []
    @past_multiples_of_fourty.each_with_index do |m, i|
      score << @signal_during_multiple_of_fourty[i] * m
    end

    score.sum
  end

  private

  def _consider_multiple_of_fourty
    if @current_cycle == @next_multiple_of_fourty
      @signal_during_multiple_of_fourty << @signal_strength
      @past_multiples_of_fourty << @current_cycle + 1
      @next_multiple_of_fourty += 40
    end

    # puts [@current_cycle, "x", @signal_strength].join
  end
end

def read_file(file)
  contents = []
  f = File.open(file, "r")
  f.each_line do |line|
    contents << line.strip.split(' ')
  end
  contents
end

use_input = true
file = use_input ? '2022/day_10/input.txt' : '2022/day_10/example.txt'
contents = read_file(file)

x = Xvalue.new(1)
contents.each do |command|
  x.execute_command(command)
end

puts x.score