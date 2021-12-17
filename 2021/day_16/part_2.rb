file='2021/day_16/input.txt'
bits = nil

f = File.open(file, "r")
f.each_line do |line|
  bits = line.strip.split('').map do |bit|
    bit.to_i(16).to_s(2).rjust(4,'0')
  end.join('')
end

def get_header(bits)
  return [0,0,nil] if bits.nil? || !bits.include?('1')
  version_bits = bits[0..2]
  type_id_bits = bits[3..5]
  bits = bits[6..-1]

  version = version_bits.to_i(2)
  type_id = type_id_bits.to_i(2)

  [version, type_id, bits]
end

def parse_literal(bits, nums)
  finished = false
  bank = []

  while finished == false
    if bits[0] == '1'
      bank << bits[1..4]
      bits = bits[5..-1]
    else
      bank << bits[1..4]
      bits = bits[5..-1]
      finished = true
    end
  end
  nums << bank.join('').to_i(2)
  
  [bits, nums]
end

def remove_trailing_zeros(bits)
  while bits[0] == '0'
    bits = bits[1..-1]
    return bits if bits.length == 0
  end

  bits
end

def find_inners_zero(bits, score, nums)
  [bits, score, nums] if bits.nil?

  length_requirement = bits[1..15].to_i(2)
  bits = bits[16..-1]
  target_bits_length = bits.length - length_requirement
  bank = []

  until bits.nil? || bits.length <= target_bits_length
    version, type_id, bits = get_header(bits) 
    bits, score, nums = parse_packet(version, type_id, bits, score, nums)

    bank.concat(nums)
    nums = []
  end
  bank.concat(nums)
  
  [bits, score, bank]
end

def find_inners_one(bits, score, nums)
  [bits, score, nums] if bits.nil?

  target_count = bits[1..11].to_i(2)
  bits = bits[12..-1]
  bank = []
  count = 0

  until bits.nil? || count == target_count
    version, type_id, bits = get_header(bits)
    bits, score, nums = parse_packet(version, type_id, bits, score, nums)

    bank.concat(nums)
    nums = []
    count += 1
  end
  bank.concat(nums)

  [bits, score, bank]
end

def parse_packet(version, type_id, bits, score, nums)
  return [bits, score, nums] if bits.nil?
  length_type_id = bits[0]

  pp type_id

  case type_id

  when 0
    if length_type_id == '0'
      bits, score, nums = find_inners_zero(bits, score, nums)
    else
      bits, score, nums = find_inners_one(bits, score, nums)
    end

    ans = nums.inject(:+)
    score = ans
    nums = [ans]

  when 1
    if length_type_id == '0'
      bits, score, nums = find_inners_zero(bits, score, nums)
    else
      bits, score, nums = find_inners_one(bits, score, nums)
    end

    ans = nums.inject(:*)
    score = ans
    nums = [ans]

  when 2
    if length_type_id == '0'
      bits, score, nums = find_inners_zero(bits, score, nums)
    else
      bits, score, nums = find_inners_one(bits, score, nums)
    end

    ans = nums.min
    score = ans
    nums = [ans]
  
  when 3
    if length_type_id == '0'
      bits, score, nums = find_inners_zero(bits, score, nums)
    else
      bits, score, nums = find_inners_one(bits, score, nums)
    end

    ans = nums.max
    score = ans
    nums = [ans]

  when 4
    bits, nums = parse_literal(bits, nums)

  when 5
    if length_type_id == '0'
      bits, score, nums = find_inners_zero(bits, score, nums)
    else
      bits, score, nums = find_inners_one(bits, score, nums)
    end


    ans = nums[0] > nums[1] ? 1 : 0
    score = ans
    nums = [ans]

  when 6
    if length_type_id == '0'
      bits, score, nums = find_inners_zero(bits, score, nums)
    else
      bits, score, nums = find_inners_one(bits, score, nums)
    end

    ans = nums[0] < nums[1] ? 1 : 0
    score = ans
    nums = [ans]

  when 7
    if length_type_id == '0'
      bits, score, nums = find_inners_zero(bits, score, nums)
    else
      bits, score, nums = find_inners_one(bits, score, nums)
    end
 
    ans = nums[0] == nums[1] ? 1 : 0
    score = ans
    nums = [ans]
  end

  [bits, score, nums]
end

def calculate_expression(bits)
  score = 0

  while bits.include?('1')
    version, type_id, bits = get_header(bits)

    bits, score, nums = parse_packet(version, type_id, bits, score, [])
    break if bits.nil?
    bits = remove_trailing_zeros(bits)
  end

  score
end

pp calculate_expression(bits)
