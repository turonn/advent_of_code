file='2021/day_6/input.txt'
days_to_measure = 80

def birth_fish_and_reset_clock(fish_array)
  new_fish = fish_array.count(-1)

  fish_array = fish_array.map do |fish|
    if fish < 0
      fish = 6
    else
      fish
    end
  end

  new_fish.times do 
    fish_array << 8
  end

  fish_array
end

def number_of_fish_after_given_days(file, days_to_measure)
  f = File.open(file, "r")
  fish_array = []
  f.each_line { |line| fish_array = line.split(',').map(&:to_i) }
  
  day = 0
  while day < days_to_measure
    fish_array = fish_array.map { |v| v - 1 }

    fish_array = birth_fish_and_reset_clock(fish_array)
    day += 1
  end

  fish_array.count
end

pp number_of_fish_after_given_days(file, days_to_measure)