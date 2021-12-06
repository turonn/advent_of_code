file='2021/day_6/input.txt'
days_to_measure = 256

def fish_array_to_hash(fish_array)
  {
    -1 => fish_array.count(-1),
    0 => fish_array.count(0),
    1 => fish_array.count(1),
    2 => fish_array.count(2),
    3 => fish_array.count(3),
    4 => fish_array.count(4),
    5 => fish_array.count(5),
    6 => fish_array.count(6),
    7 => fish_array.count(7),
    8 => fish_array.count(8)
  }
end

def age_and_birth_fish(fish_hash)
  {
    0 => fish_hash[1],
    1 => fish_hash[2],
    2 => fish_hash[3],
    3 => fish_hash[4],
    4 => fish_hash[5],
    5 => fish_hash[6],
    6 => (fish_hash[7] + fish_hash[0]),
    7 => fish_hash[8],
    8 => fish_hash[0]
  }
end

def number_of_fish_after_given_days(file, days_to_measure)
  f = File.open(file, "r")
  fish_array = []
  f.each_line { |line| fish_array = line.split(',').map(&:to_i) }

  fish_hash = fish_array_to_hash(fish_array)
  
  day = 0
  while day < days_to_measure
    fish_hash = age_and_birth_fish(fish_hash)
    day += 1
  end

  sum_fish(fish_hash)
end

def sum_fish(fh)
  fh[0] + fh[1] + fh[2] + fh[3] + fh[4] + fh[5] + fh[6] + fh[7] + fh[8]
end

pp number_of_fish_after_given_days(file, days_to_measure)