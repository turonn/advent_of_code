file='2020/day_4/input.txt'
valid_passports = []
current_passport = {}

def check_if_valid_passport(passport)
  if passport.size == 8
    true
  elsif passport.size == 7
    unless passport.key?("cid")
      true
    end
  else
    false
  end
end

f = File.open(file, "r")
f.each_line do |line|
  if line.strip.empty?
    if check_if_valid_passport(current_passport)
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

if check_if_valid_passport(current_passport)
  valid_passports << current_passport
end

puts valid_passports.count
