answer = []
ARGF.each_line do |line|
  arr = line.split(' ')
  arr[0] = arr[0].split('-')
  arr[1].delete!(':')

  count = arr[2].count(arr[1])

  if arr[0][0].to_i <= count && count <= arr[0][1].to_i
    answer << arr[2]
  end
end

puts answer.count
