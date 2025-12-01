dial = 50
zero_count = 0

File.open('2025/day_1/input.txt', "r").each_line do |line|
  started_at_zero = dial == 0

  direction = line.strip[0]
  distance = line.strip[1..-1].to_i

  full_rotations = distance / 100
  zero_count += full_rotations

  remainder = distance % 100
  movement = direction == 'L' ? -remainder : remainder
  dial = dial + movement

  if dial > 99
    dial -= 100
    zero_count += 1 unless started_at_zero && dial == 0
  elsif dial < 0
    dial += 100
    zero_count += 1 unless started_at_zero
  elsif dial == 0
    zero_count += 1 unless started_at_zero
  end
end

puts zero_count
