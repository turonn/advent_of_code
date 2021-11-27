file='2020/day_4/input.txt'
valid_passports = []
current_passport = {}

def is_valid_passport(passport)
  if passport.size < 7
    false
  elsif passport.size == 7 && passport.key?("cid")
    false
  else
    check_values_of_passport(passport)
  end
end

def check_values_of_passport(passport)
  passport.each do |k, v|
    case k
      when "byr"
        unless is_correct_length(v, 4) && made_up_of_digits(v) && check_within_range(v.to_i, 1920, 2002) 
          return false
        end

      when "iyr"
        unless is_correct_length(v, 4) && made_up_of_digits(v) && check_within_range(v.to_i, 2010, 2020)
          return false
        end

      when "eyr"
        unless is_correct_length(v, 4) && made_up_of_digits(v) && check_within_range(v.to_i, 2020, 2030)
          return false
        end

      when "hgt"
        unless made_up_of_digits(v[0...-2])
          return false
        end

        case v[-2..-1]
          when "cm"
            unless check_within_range(v[0...-2].to_i, 150, 193)
              return false
            end
          when "in"
            unless check_within_range(v[0...-2].to_i, 59, 76)
              return false
            end
          else
            return false
        end

      when "hcl"
        unless v[0] == "#" && is_correct_length(v, 7) && is_hexkey(v[1..-1])
          return false
        end

      when "ecl"
        unless ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(v)
          return false
        end

      when "pid"
        unless is_correct_length(v, 9) && made_up_of_digits(v)
          return false
        end

      when "cid"

      else
        return false
    end
  end
  true
end

def check_within_range(integer, earliest, latest)
  if integer.to_i < earliest || latest < integer.to_i
    false
  else
    true
  end
end

def is_correct_length(string, length)
  if string.length == length
    true
  else
    false
  end
end

def made_up_of_digits(string)
  string.chars.each do |char|
    return false unless char.match(/\d/)
  end
end

def is_hexkey(string)
  string.chars.each do |char|
    return false unless char.match(/[0-9A-Fa-f]/)
  end
  true
end

f = File.open(file, "r")
f.each_line do |line|
  if line.strip.empty?
    if is_valid_passport(current_passport)
      valid_passports << current_passport
    end
    current_passport = {}
  end

  arr = line.strip.split(' ')
  arr.map do |v|
    k_v = v.split(':')
    current_passport[k_v[0]] = k_v[1]
  end
end

if is_valid_passport(current_passport)
  valid_passports << current_passport
end

puts valid_passports.count
