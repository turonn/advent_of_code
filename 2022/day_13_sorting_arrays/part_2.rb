require 'json'

class Packet
  attr_accessor :value, :index

  @@all ||= []

  def initialize(value)
    @value = value
    @@all << self
  end

  def self.all
    @@all
  end

  def self.sort_and_index
    @@all = @@all.sort

    @@all.each_with_index do |packet, index|
      packet.index = index + 1
    end
  end

  def self.left_is_smaller?(left, right)
    left.each_with_index do |l, i|
      r = right[i]
      if l.is_a?(Integer) && r.is_a?(Integer)
        next if l == r
        return l < r
      elsif l.is_a?(Array) && r.is_a?(Array)
        ans = left_is_smaller?(l, r)
        return ans unless ans.nil?
      elsif l.is_a?(Array) && r.is_a?(Integer)
        ans = left_is_smaller?(l, [r])
        return ans unless ans.nil?
      elsif l.is_a?(Integer) && r.is_a?(Array)
        ans = left_is_smaller?([l], r)
        return ans unless ans.nil?
      elsif r.nil?
        return false
      end
    end

    return true if left.length < right.length
    nil
  end

  def <=>(other)
    return 0 if @value === other.value
    return -1 if Packet.left_is_smaller?(@value, other.value)
    1
  end
end

def read_file_and_create_packets(file)
  f = File.open(file, "r")
  f.each_line do |line|
    next if line == "\n"
    Packet.new(JSON.parse(line))
  end
end

use_input = true
file = use_input ? '2022/day_13/input.txt' : '2022/day_13/example.txt'
read_file_and_create_packets(file)

Packet.sort_and_index

two_packet = Packet.all.detect { |packet| packet.value == [[2]] }
six_packet = Packet.all.detect { |packet| packet.value == [[6]] }

puts two_packet.index * six_packet.index
