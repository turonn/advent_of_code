file='2021/day_3/input.txt'
orriginal_array = []
f = File.open(file, "r")

f.each_line do |line|
  orriginal_array << line.strip.split('')
end

def reverse_digit(digit)
  digit == 1 ? 0 : 1
end

def find_most_common_digit_at_index(master_list, index)
  counter = 0
  
  master_list.each do |arr|
    counter += arr[index].to_i
  end

  counter >= master_list.size/2.0 ? 1 : 0
end

def arrays_that_match_index(master_list, index, digit_to_match)
  master_list.select do |arr|
    arr[index].to_i == digit_to_match
  end
end

def find_last_array_standing(master_list, most_bool)
  index = 0

  while master_list.size > 1
    digit = find_most_common_digit_at_index(master_list, index)
    most_bool ? digit_to_match = digit : digit_to_match = reverse_digit(digit)

    master_list = arrays_that_match_index(master_list, index, digit_to_match)

    index += 1
  end

  master_list.first
end


oxegen_answer = find_last_array_standing(orriginal_array, true)
co2_answer = find_last_array_standing(orriginal_array, false)

puts oxegen_answer.join('').to_i(2) * co2_answer.join('').to_i(2)
