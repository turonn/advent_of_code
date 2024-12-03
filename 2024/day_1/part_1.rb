file='2024/day_1/input.txt'
left_list = []
right_list = []

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split('   ')
  
  left_list << arr[0].to_i
  right_list << arr[1].to_i
end

left_list.sort!
right_list.sort!

answer = 0

left_list.each_with_index do |l, i|
  answer = answer + (l - right_list[i]).abs
end

pp answer