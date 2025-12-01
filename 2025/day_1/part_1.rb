dial = 50
zero_count = 0

File.open('2025/day_1/input.txt', "r").each_line do |line|
  direction = line.strip[0]
  distance = line.strip[1..-1].to_i

  case direction
  when 'R' then dial = (dial + distance)
  when 'L' then dial = (dial - distance)
  end

  while dial > 99
    dial -= 100
  end

  while dial < 0
    dial += 100
  end

  zero_count += 1 if dial == 0
end

puts zero_count
