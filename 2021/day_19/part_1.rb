
def get_data
  file='2021/day_19/example.txt'
  all_scanners = []
  skip = true
  scanner = []

  f = File.open(file, "r")
  f.each_line do |line|
    if skip
      skip = false
      next
    end

    arr = line.strip

    if arr.empty?
      skip = true
      all_scanners << scanner
      scanner = []
      next
    end

    scanner << arr.split(',').map(&:to_i)
  end

  all_scanners << scanner
end

# def get_distance(point_1, point_2)
#   Math.sqrt((point_1[0] - point_2[0])**2 + (point_1[1] - point_2[1])**2 + (point_1[2] - point_2[2])**2)
# end

def get_distance_data(scanner)
  distance_data = []
  
  scanner.each do |beacon_1|
    distances = []
    
    scanner.each do |beacon_2|
      next if beacon_1 == beacon_2
      distances << {
        b2: beacon_2,
        f: beacon_1[0] - beacon_2[0],
        s: beacon_1[1] - beacon_2[1],
        t: beacon_1[2] - beacon_2[2]
      }
      # distances << get_distance(beacon_1, beacon_2)
    end
    
    distance_data << {
      pos: beacon_1,
      dist: distances
    }
  end
  
  distance_data
end

def get_all_distance_data(all_scanners)
  distance_data = []
  all_scanners.each do |scanner|
    distance_data << get_distance_data(scanner)
  end

  distance_data
end

def is_a_match?(beacon_1, beacon_2)
  beacon_1[:dist].each do |dist_1|
    beacon_2[:dist].each do |dist_2|
      
    end
  end
end

def get_number_of_matches(s_dd_2, beacon_1)
  same = 0
  s_dd_2.each do |beacon_2|  
    if is_a_match?(beacon_1, beacon_2)
      same += 1
    end
  end
  pp same
  same
end

def get_shared_beacons(s_dd_1, s_dd_2)
  shared_beacons = []
  count = 0
  s_dd_1.each do |beacon_1|
    if get_number_of_matches(s_dd_2, beacon_1) >= 12
      count += 1
      pp count
    end
  end
  pp s_dd_1 == s_dd_2
  nil
end

all_scanners = get_data()
distance_data = get_all_distance_data(all_scanners)

pp get_shared_beacons(distance_data[0], distance_data[1])