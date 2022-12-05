file='2022/day_5/input.txt'
sideways_stacks = []
stacks = {}
giving_directions = false
directions = []

def rearrange_stacks(sideways_stacks)
  stacks = {}
  number_of_columns = sideways_stacks.first.length / 4
  number_of_columns.times do |i|
    stacks[i + 1] = []
  end

  sideways_stacks.each do |row|
    column = 1
    until column > number_of_columns
      crate = row.take(column * 4)[1 + ((column - 1) * 4)]
      unless crate == ' '
        stacks[column] << crate
      end
      column += 1
    end
  end

  stacks.each do |k, v|
    stacks[k] = v.reverse
  end
end

f = File.open(file, "r")
f.each_line do |line|
  if line == "\n"
    giving_directions = true
    stacks = rearrange_stacks(sideways_stacks[0..-2])
    next
  end
  
  if giving_directions
    dir = line.strip.split(' ')

    directions << [dir[1].to_i, dir[3].to_i, dir[5].to_i]
  else
    sideways_stacks << line.split('')
  end
end

# move 1 from 2 to 1
def perform_direction(stacks, direction)
  transit_crates = stacks[direction[1]].pop(direction[0])
  transit_crates.to_a if direction[0] == 1
  stacks[direction[2]].concat(transit_crates.reverse)

  stacks
end

def follow_directions(stacks, directions)
  directions.each do |direction|
    stacks = perform_direction(stacks, direction)
  end

  stacks
end

stacks = follow_directions(stacks, directions)

ans = []
stacks.count.times do |i|
  ans << stacks[i + 1].last
end

puts ans.join