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

def parse_literal(bits)
  finished = false

  while finished == false
    if bits[0] == '1'
      # remove five
      bits = bits[5..-1]
    else
      bits = bits[5..-1]
      finished = true
    end
  end

  bits
end

def remove_trailing_zeros(bits)
  while bits[0] == '0'
    bits = bits[1..-1]
    return bits if bits.length == 0
  end

  bits
end

def parse_packet(version, type_id, bits, version_score, count)
  pp bits
  return [bits, version_score, count] if bits.nil?

  if type_id == 4
    bits = parse_literal(bits)
  else
    length_type_id = bits[0]

    if length_type_id == '0'
      length_requirement = bits[1..15].to_i(2)
      bits = bits[16..-1]
      target_bits_length = bits.length - length_requirement

      until bits.nil? || bits.length <= target_bits_length
        version, type_id, bits = get_header(bits)
        version_score += version
        
        bits, version_score, count = parse_packet(version, type_id, bits, version_score, count)
      end

    else
      length = bits[1..11].to_i(2)
      target_count = count + length
      bits = bits[12..-1]

      until bits.nil? || count == target_count
        version, type_id, bits = get_header(bits)
        version_score += version

        bits, version_score, count = parse_packet(version, type_id, bits, version_score, count)
      end
    end
  end

  count += 1
  [bits, version_score, count]
end

def get_version_score(bits)
  version_score = 0
  count = 0

  while bits.include?('1')
    version, type_id, bits = get_header(bits)
    version_score += version

    bits, version_score, count = parse_packet(version, type_id, bits, version_score, count)
    break if bits.nil?
    bits = remove_trailing_zeros(bits)
  end

  version_score
end

pp get_version_score(bits)
