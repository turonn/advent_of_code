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
      return num
    end
  end 
end

def get_list_that_sum_to_num(file, faulty_num)
  f = File.open(file, "r")
  first_line = true
  list = []

  f.each_line do |line|
    num = line.strip.to_i
    list << num

    if list.inject(:+) > faulty_num
      while list.inject(:+) > faulty_num
        list = list.drop(1)
        break if list.size == 0
      end
    end

    return list if list.inject(:+) == faulty_num
  end
end

def get_the_answer(file, preamble_length)
  faulty_num = get_first_num_that_breaks_the_rule(file, preamble_length)

  list = get_list_that_sum_to_num(file, faulty_num)
  answer = list.min + list.max

  puts answer
end

get_the_answer(file, preamble_length)