def read_file(file)
  contents = []
  f = File.open(file, "r")
  f.each_line do |line|
    arr = line.strip.split('')
    
  end

  contents
end

use_input = false
file = use_input ? '2022/day_13/input.txt' : '2022/day_13/example.txt'
contents = read_file(file)