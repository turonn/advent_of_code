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

def count_unique(length, dig)
  case length
  when 2
    1
  when 3
    1
  when 4
    1
  when 7
    1
  else
    0
  end
end

pannel.each do |p|
  p[1].each do |dig|
    number_of_unique += count_unique(dig.size, dig)
   end
end

pp number_of_unique