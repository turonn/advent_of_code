file='2021/day_17/input.txt'
target_x = nil
target_y = nil

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split(' ')
  
  target_x = arr[2][2..-2].split('..').map(&:to_i)
  target_y = arr[3][2..-1].split('..').map(&:to_i)
end

def find_x_velosity_range(target_x)
  how_far_it_goes = 0
  min_velosity = 0

  while how_far_it_goes < target_x[0]
    how_far_it_goes = 0
    velosity = min_velosity

    while velosity > 0
      how_far_it_goes += velosity
      velosity -= 1
    end

    min_velosity += 1
  end

  [min_velosity - 1, target_x[1]]
end

min_x, max_x = find_x_velosity_range(target_x)

def find_y_velosity_range(target_y)
  [target_y[0], -(target_y[0] + 1) ]
end

min_y, max_y = find_y_velosity_range(target_y)

def out_of_y_range(y_v, target_y)
  y = y_v
  height = 0

  until height < target_y[0]
    height += y
    y -= 1
    return false if (target_y[0] <= height && height <= target_y[1])
  end
  true
end

y_groups = []
(min_y..max_y).to_a.each do |y_v|
  next if out_of_y_range(y_v, target_y)
  y = y_v
  height = 0
  t = 0
 
  until target_y[0] <= height && height <= target_y[1]
    t += 1
    height += y
    y -= 1
  end

  times = []
  while target_y[0] <= height && height <= target_y[1]
    times << t
    t += 1
    height += y
    y -= 1
  end

  y_groups << {
    y: y_v,
    t: times
  }
end

def out_of_x_range(x_v, target_x)
  x = x_v
  dist = 0

  until dist > target_x[1] || x < 0
    dist += x
    x -= 1
    return false if (target_x[0] <= dist && dist <= target_x[1])
  end
  true
end

x_groups = []
(min_x..max_x).to_a.each do |x_v|
  next if out_of_x_range(x_v, target_x)
  x = x_v
  dist = 0
  t = 0
 
  until target_x[0] <= dist && dist <= target_x[1]
    t += 1
    dist += x
    x -= 1
  end

  times = []
  while target_y[0] <= dist && dist <= target_x[1]
    if x == -1
      x_groups << {
        x: x_v,
        t: [times.first],
        stopped_in_target: true
      }
      break
    end
    times << t
    t += 1
    dist += x
    x -= 1
  end

  unless x_groups.any? { |xg| xg[:x] == x_v }  
    x_groups << {
      x: x_v,
      t: times,
      stopped_in_target: false
    }
  end
end

pairs = []
x_groups.each do |x|
  if x[:stopped_in_target]
    gg = y_groups.select { |y| y[:t].any? { |t| t >= x[:t].first } }

    unless gg.nil?
      gg.each do |y|
        pairs << [x[:x], y[:y]]
      end
    end
    next
  end

  y_groups.each do |y|
    y[:t].each do |t|
      if x[:t].include?(t)
        pairs << [x[:x], y[:y]]
      end
    end
  end
end

pp pairs.uniq.count
