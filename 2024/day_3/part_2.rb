file = '2024/day_3/input.txt'

sum = 0
one_to_three_digits = /\A\d{1,3}/
$perform = true
f = File.open(file, "r")

def _search_for_dos(str)
  last_dont_index = str.rindex("don't()")
  last_do_index = str.rindex("do()")

  if last_do_index
    if last_dont_index.nil? || last_do_index < last_do_index
      $perform = true
    end
  elsif last_dont_index
    if last_do_index.nil? || last_do_index > last_dont_index
      $perform = false
    end
  end
end

f.each_line do |line|
  stubs = line.strip.split('mul(')

  stubs.each do |str|
    first_num = str.slice!(one_to_three_digits)
    next _search_for_dos(str) if first_num.nil?
    comma = str.slice!(/\A,/)
    next _search_for_dos(str) if comma.nil?
    second_num = str.slice!(one_to_three_digits)
    next _search_for_dos(str) if second_num.nil?
    paren = str.slice! /\A\)/
    next _search_for_dos(str) if paren.nil?

    sum += first_num.to_i * second_num.to_i if $perform
    _search_for_dos(str) 
  end
  
end

pp sum