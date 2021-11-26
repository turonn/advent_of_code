answer = []

ARGF.each_line do |line|
  arr = line.split(' ')
  arr[0] = arr[0].split('-')
  arr[1].delete!(':')

  indexes = (0 ... arr[2].length).find_all { |i| arr[2][i] == arr[1] }

  indexes.map! { |i| i + 1 }

  if indexes.include?(arr[0][0].to_i) || indexes.include?(arr[0][1].to_i)
    unless indexes.include?(arr[0][0].to_i) && indexes.include?(arr[0][1].to_i)
      answer << line
    end
  end
end

puts answer.count