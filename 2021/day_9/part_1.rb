file='2021/day_9/input.txt'
horizontal_low_points = []
line_num = 0
data_set = []

f = File.open(file, "r")
f.each_line do |line|
  line_comp = []
  nums = line.strip.split('')
  data_set << nums.map(&:to_i)
  starting_num = true
  
  nums.each_with_index do |n, i|
    line_comp << n.to_i

    next if line_comp.size < 2
    
    if line_comp.size == 2
      if line_comp[0] < line_comp[1]
        horizontal_low_points <<  {
          value: line_comp[0],
          hoz_pos: 0,
          ver_pos: line_num
        }
      end

    else
      if i == (nums.count - 1)
        if line_comp[1] > line_comp[2]
          horizontal_low_points <<  {
            value: line_comp[2],
            hoz_pos: i,
            ver_pos: line_num
          }
        end
      end

      if (line_comp[0] > line_comp[1]) && (line_comp[1] < line_comp[2])
        horizontal_low_points <<  {
          value: line_comp[1],
          hoz_pos: i - 1,
          ver_pos: line_num
        }
      end
      line_comp = line_comp[1..2]
    end
  end

  line_num += 1
end

low_vals = []
horizontal_low_points.each do |point|
  if point[:ver_pos] == 0
    if (data_set[point[:ver_pos] +1 ][point[:hoz_pos]] > point[:value])
      low_vals << point[:value]
    end
    next

  elsif point[:ver_pos] == (data_set.count - 1)
    if (data_set[point[:ver_pos] - 1][point[:hoz_pos]] > point[:value])
      low_vals << point[:value]
    end
    next
  end

  if (data_set[point[:ver_pos] - 1][point[:hoz_pos]] > point[:value]) && (data_set[point[:ver_pos] + 1][point[:hoz_pos]] > point[:value])
    low_vals << point[:value]
  end
end

pp low_vals.map { |n| n += 1 }.inject(:+)