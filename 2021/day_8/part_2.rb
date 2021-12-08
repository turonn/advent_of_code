file='2021/day_8/input.txt'
pannel = []

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split(' | ')
  input_args = arr[0].split(' ')
  output_args = arr[1].split(' ')
  
  pannel << [input_args, output_args]
end

number_of_unique = 0

def check_for_known_solution(dig, solved_digits)
  case dig.size
  when 2
    solved_digits.merge!({ 1 => dig })
  when 3
    solved_digits.merge!({ 7 => dig })
  when 4
    solved_digits.merge!({ 4 => dig })
  when 7
    solved_digits.merge!({ 8 => dig })
  else
    solved_digits
  end
end

def solve_other_digits(solved_digits, input)
  full_solution = solved_digits

  five_digit_digits = input.select { |dig| dig.size == 5 }
  solved_digits[3] = five_digit_digits.select { |dig| (dig.split('') & solved_digits[1].split('')).size == 2 }.first
  five_digit_digits.delete(solved_digits[3])
  solved_digits[5] = five_digit_digits.select { |dig| (dig.split('') & solved_digits[4].split('')).size == 3 }.first
  five_digit_digits.delete(solved_digits[5])
  solved_digits[2] = five_digit_digits.first

  six_digit_digits = input.select { |dig| dig.size == 6 }
  solved_digits[0] = six_digit_digits.select { |dig| (dig.split('') & solved_digits[5].split('')).size == 4 }.first
  six_digit_digits.delete(solved_digits[0])
  solved_digits[9] = six_digit_digits.select { |dig| (dig.split('') & solved_digits[1].split('')).size == 2 }.first
  six_digit_digits.delete(solved_digits[9])
  solved_digits[6] = six_digit_digits.first

  solved_digits
end

sum = 0
pannel.each do |p|
  solved_digits = {}
  input = p[0]
  output = p[1]
  
  input.each do |dig|
    solved_digits = check_for_known_solution(dig, solved_digits)

    break if solved_digits.size == 4
  end

  solved_digits = solve_other_digits(solved_digits, input)

  output_nums = []
  output.map do |dig|
    solved_digits.each do |k, v|
      if ((dig.split('') & v.split('')).size == dig.size) && ((dig.split('') & v.split('')).size == v.size)
        output_nums << k
        break
      end
    end
  end

  sum += output_nums.join('').to_i
end

pp sum