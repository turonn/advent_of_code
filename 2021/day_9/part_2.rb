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

low_points = []
horizontal_low_points.each do |point|
  if point[:ver_pos] == 0
    if (data_set[point[:ver_pos] +1 ][point[:hoz_pos]] > point[:value])
      low_points << point
    end
    next

  elsif point[:ver_pos] == (data_set.count - 1)
    if (data_set[point[:ver_pos] - 1][point[:hoz_pos]] > point[:value])
      low_points << point
    end
    next
  end

  if (data_set[point[:ver_pos] - 1][point[:hoz_pos]] > point[:value]) && (data_set[point[:ver_pos] + 1][point[:hoz_pos]] > point[:value])
    low_points << point
  end
end

def compare_left(data_set, point)
  return nil if (point[:hoz_pos] == 0)
  left_val = data_set[point[:ver_pos]][point[:hoz_pos] - 1]

  if (point[:value] > left_val) || (left_val == 9)
    return nil
  else
    {
      value: left_val,
      hoz_pos: (point[:hoz_pos] - 1),
      ver_pos: point[:ver_pos]
    }
  end
end

def compare_up(data_set, point)
  return nil if (point[:ver_pos] == 0)
  up_val = data_set[point[:ver_pos] - 1][point[:hoz_pos]]

  if (point[:value] > up_val) || (up_val == 9)
    return nil
  else
    {
      value: up_val,
      hoz_pos: point[:hoz_pos],
      ver_pos: (point[:ver_pos] -1)
    }
  end
end

def compare_right(data_set, point)
  return nil if (point[:hoz_pos] == (data_set.first.size - 1))
  right_val = data_set[point[:ver_pos]][point[:hoz_pos] + 1]

  if (point[:hoz_pos] == 0) || (point[:value] > right_val) || (right_val == 9)
    return nil
  else
    {
      value: right_val,
      hoz_pos: (point[:hoz_pos] + 1),
      ver_pos: point[:ver_pos]
    }
  end
end

def compare_down(data_set, point)
  return nil if (point[:ver_pos] == (data_set.size - 1))
  down_val = data_set[point[:ver_pos] + 1][point[:hoz_pos]]

  if (point[:value] > down_val) || (down_val == 9)
    return nil
  else
    {
      value: down_val,
      hoz_pos: point[:hoz_pos],
      ver_pos: (point[:ver_pos] +1)
    }
  end
end

basins = low_points.map do |point|
  basin = []
  new_points = [point]

  while new_points.size > 0
    basin.concat(new_points)
    new_new_points = []

    new_points.each do |point|
      new_left_point = compare_left(data_set, point) 
      unless new_left_point.nil? || basin.include?(new_left_point) || new_new_points.include?(new_left_point)
        new_new_points << new_left_point
      end

      new_right_point = compare_right(data_set, point) 
      unless new_right_point.nil? || basin.include?(new_right_point) || new_new_points.include?(new_right_point)
        new_new_points << new_right_point
      end

      new_up_point = compare_up(data_set, point) 
      unless new_up_point.nil? || basin.include?(new_up_point) || new_new_points.include?(new_up_point)
        new_new_points << new_up_point
      end

      new_down_point = compare_down(data_set, point) 
      unless new_down_point.nil? || basin.include?(new_down_point) || new_new_points.include?(new_down_point)
        new_new_points << new_down_point
      end
    end

    new_points = new_new_points
  end
  
  basin.size
end

pp basins.sort!.reverse[0..2].inject(:*)

