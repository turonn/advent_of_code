require 'json'

class Pair
  attr_accessor :right, :left, :is_in_order
  attr_reader :index

  def initialize(left, right)
    @left = left
    @right = right
    @index = @@all.count + 1
    @is_in_order = nil
  end

  def determine_if_in_order(left,right)
    left.each_with_index do |l, i|
      r = right[i]
      if l.is_a?(Integer) && r.is_a?(Integer)
        next if l == r
        @is_in_order = l < r
        return
      elsif l.is_a?(Array) && r.is_a?(Array)
        determine_if_in_order(l, r)
        return unless @is_in_order.nil?
      elsif l.is_a?(Array) && r.is_a?(Integer)
        determine_if_in_order(l, [r])
        return unless @is_in_order.nil?
      elsif l.is_a?(Integer) && r.is_a?(Array)
        determine_if_in_order([l], r)
        return unless @is_in_order.nil?
      elsif r.nil?
        @is_in_order = false
        return
      end
    end

    if left.length < right.length
      @is_in_order = true
    end
  end
end

def read_file(file)
  pairs = []
  right = nil
  left = nil
  current_line = 1
  f = File.open(file, "r")
  f.each_line do |line|
    case current_line
    when 1
      left = JSON.parse(line)
    when 2
      right = JSON.parse(line)
      pairs << Pair.new(left, right)
    when 3
      current_line = 1
      next
    end

    current_line += 1
  end

  pairs
end

use_input = true
file = use_input ? '2022/day_13/input.txt' : '2022/day_13/example.txt'
pairs = read_file(file)

pairs.each do |pair|
  pair.determine_if_in_order(pair.left, pair.right)
  pair.is_in_order = pair.is_in_order.nil? ? true : pair.is_in_order
end

puts pairs.select(&:is_in_order).map(&:index).sum