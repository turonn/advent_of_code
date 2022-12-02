file = '2022/day_2/input.txt'
rounds = []

lose_points = 0
draw_points = 3
win_points = 6

rock_points = 1
paper_points = 2
sissors_points = 3

f = File.open(file, 'r')
f.each_line do |line|
  round = line.strip.split(' ')

  rounds << case round[0]
            when 'A'
              case round[1]
              when 'X'
                draw_points + rock_points
              when 'Y'
                win_points + paper_points
              when 'Z'
                lose_points + sissors_points
              end
            when 'B'
              case round[1]
              when 'X'
                lose_points + rock_points
              when 'Y'
                draw_points + paper_points
              when 'Z'
                win_points + sissors_points
              end
            when 'C'
              case round[1]
              when 'X'
                win_points + rock_points
              when 'Y'
                lose_points + paper_points
              when 'Z'
                draw_points + sissors_points
              end
            end
end

puts rounds.sum
