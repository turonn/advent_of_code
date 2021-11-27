file='2020/day_5/input.txt'
taken_seats = []

def walk_binary_tree(data, num)
  seat = 0
  steps = num/2
  data.each do |h|
    if h == "B" || h == "R"
      seat += steps
    end
    steps /= 2
  end
  seat
end

def calculate_seat_id(row, column)
  row * 8 + column
end

def find_seat(arr)
  arr.each_with_index do |seat, i|
    unless arr[i + 1] == (seat + 1)
      return seat + 1
    end
  end
end

f = File.open(file, "r")
f.each_line do |line|
  row_data = line.strip.split('').first(7)
  column_data = line.strip.split('').last(3)

  row = walk_binary_tree(row_data, 128)
  column = walk_binary_tree(column_data, 8)
  
  taken_seats << calculate_seat_id(row, column)
end

puts find_seat(taken_seats.sort)
 