class Monkey
  attr_accessor :items_held, :inspection_count

  @@all ||= {}
  @@lcm ||= 1

  def initialize(monkey_number, starting_items, operation, divisible_by_test_condition, true_monkey, false_monkey)
    @monkey_number = monkey_number
    @items_held = starting_items
    @operation = operation
    @divisible_by_test_condition = divisible_by_test_condition
    @true_monkey = true_monkey
    @false_monkey = false_monkey
    @inspection_count = 0

    @@all[monkey_number] = self
    @@lcm *= divisible_by_test_condition
  end

  def self.all
    @@all
  end

  def inspect_and_toss_item
    return if @items_held.first.nil?
    item = @items_held.first
    item = _operate_item(item)
    _toss_item(item)
    @inspection_count += 1
  end

  private

  def _operate_item(item)
    number_to_operate = (@operation[1] == 'old') ? item : @operation[1]

    case @operation[0]
    when "+"
      item += number_to_operate
    when "*"
      item *= number_to_operate
    end

    item = item % @@lcm
  end

  def _toss_item(item)
    if item % @divisible_by_test_condition == 0
      Monkey.all[@true_monkey].items_held << item
    else
      Monkey.all[@false_monkey].items_held << item
    end
    @items_held = items_held.drop(1)
  end
end

def create_monkeys(file)
  monkeys = []
  monkey_number = starting_items = operation = divisible_by_test_condition = true_monkey = false_monkey = nil
  line_count = 1
  f = File.open(file, "r")
  f.each_line do |line|
    split_line = line.strip.split(' ')
    case line_count
    when 1
      monkey_number = split_line[1].delete!(":").to_i
    when 2
      starting_items = split_line.drop(2).map do |num|
        num.include?(',') ? num.delete!(",").to_i : num.to_i
      end
    when 3
      operation = [split_line[-2], split_line[-1].include?('old') ? split_line[-1] : split_line[-1].to_i]
    when 4
      divisible_by_test_condition = split_line[-1].to_i
    when 5
      true_monkey = split_line[-1].to_i
    when 6
      false_monkey = split_line[-1].to_i
    else
      monkeys << Monkey.new(monkey_number, starting_items, operation, divisible_by_test_condition, true_monkey, false_monkey)
      line_count = 1
      next
    end

    line_count += 1
  end

  monkeys << Monkey.new(monkey_number, starting_items, operation, divisible_by_test_condition, true_monkey, false_monkey)
  monkeys
end

use_input = true
file = use_input ? '2022/day_11/input.txt' : '2022/day_11/example.txt'
monkeys = create_monkeys(file)
rounds = 10000
count = 1
rounds.times do
  monkeys.each do |monkey|
    monkey.items_held.count.times do
      monkey.inspect_and_toss_item
    end
  end
end

puts monkeys.map(&:inspection_count).sort.last(2).inject(:*)
