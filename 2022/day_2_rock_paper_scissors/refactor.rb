file = '2022/day_2/input.txt'
round_points = []

lose_points = 0
draw_points = 3
win_points = 6

f = File.open(file, 'r')
f.each_line do |line|
  round = line.strip.split(' ')

  opponants_throw = case round[0]
                    when 'A' then 1 # rock
                    when 'B' then 2 # paper
                    when 'C' then 3 # scissors
                    end

  my_throw = case round[1]
             when 'X' then 1
             when 'Y' then 2
             when 'Z' then 3
             end

  score = if my_throw == opponants_throw
            draw_points
          elsif my_throw == opponants_throw + 1 || my_throw == opponants_throw - 2
            win_points
          else
            lose_points
          end

  round_points << my_throw + score
end

puts round_points.sum
