file = '2024/day_3/input.txt'

sum = 0
one_to_three_digits = /\A\d{1,3}/

f = File.open(file, "r")
f.each_line do |line|
  stubs = line.strip.split('mul(').map { |str| str.slice(0, 8) } # max string length

  stubs.each do |stub|
    first_num = stub.slice!(one_to_three_digits)
    next if first_num.nil?
    comma = stub.slice!(/\A,/)
    next if comma.nil?
    second_num = stub.slice!(one_to_three_digits)
    next if second_num.nil?
    paren = stub.slice! /\A\)/
    next if paren.nil?

    sum += first_num.to_i * second_num.to_i
  end
  
end

pp sum