file='2020/day_9/input.txt'
preamble_length = 25

def it_follows_rule?(preamble, num)
  preamble.each_with_index do |num_1, ind_1|
    preamble.each_with_index do |num_2, ind_2|
      next if ind_2 <= ind_1
      return true if (num_1 + num_2) == num
    end
  end
  
  false
end

def get_first_num_that_breaks_the_rule(file, preamble_length)
  preamble = []
  f = File.open(file, "r")

  f.each_line do |line|
    num = line.strip.to_i

    if preamble.size < preamble_length
      preamble << num
      next
    end
    
    if it_follows_rule?(preamble, num)
      preamble = preamble.drop(1)
      preamble << num
    else
      puts num
      return
    end
  end 
end

get_first_num_that_breaks_the_rule(file, preamble_length)