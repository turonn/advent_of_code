file='2021/day_17/input.txt'
target_x = nil
target_y = nil

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split(' ')
  
  target_x = arr[2][2..-2].split('..').map(&:to_i)
  target_y = arr[3][2..-1].split('..').map(&:to_i)
end

max_y = -(target_y[0] + 1)

max_height = 0
(0..max_y).to_a.each do |s|
  max_height += s
end

pp max_height
