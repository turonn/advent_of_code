file='2021/day_13/input.txt'
largest_x = 0
largest_y = 0
points = []
eof = false
insts = []

f = File.open(file, "r")
f.each_line do |line|
  raw = line.strip

  if raw.empty?
    eof = true
    next
  end

  if eof
    inst = raw.split(' ').last.split('=')
    insts << {
      dir: inst[0],
      val: inst[1].to_i
    }

  else
    arr = raw.split(',')
    points << {
      x: arr[0].to_i,
      y: arr[1].to_i
    }
  end
end

def follow_direction(points, inst)
  case inst[:dir]
  when 'x'
    left, right = points.partition { |p| p[:x] < inst[:val] }
    
    right.each do |p|
      new_x = inst[:val] - (p[:x] - inst[:val])
      new_point = {
        x: new_x,
        y: p[:y]
      }

      next if left.include?(new_point)
        
      left << new_point
    end

    return left

  when 'y'
    top, bottom = points.partition { |p| p[:y] < inst[:val] }
    
    bottom.each do |p|
      new_y = inst[:val] - (p[:y] - inst[:val])
      new_point = {
        x: p[:x],
        y: new_y
      }

      next if top.include?(new_point)
        
      top << new_point
    end

    return top
  end
end

def find_points(points, insts)
  follow_direction(points, insts.first)
end

pp find_points(points, insts).count
