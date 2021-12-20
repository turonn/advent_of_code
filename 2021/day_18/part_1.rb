require 'json'
file='2021/day_18/example.txt'
snail_nums = []

f = File.open(file, "r")
f.each_line do |line|
  snail_nums << JSON.parse(line)
end

def remove_at_nested_index(arr, indexes)
  done = false
  arr.each_with_index.map do |x, i|
    if indexes.nil? || indexes.empty?
      pp i
      pp x
      indexes = ["x"]
      next nil
    end

    next x unless i == indexes.first || done
    # pp x
    indexes = indexes.drop(1)
    arr, indexes = remove_at_nested_index(x, indexes) if x.is_a?(Array)
    done = true
  end
  # pp arr
  [arr, indexes]
end
indexes = [0,0]
arr = [[[1,2],3], 4]
# arr = [[1,[2,[3,4]]],1]
# indexes = [0,1,1]

pp remove_at_nested_index(arr, indexes)


def actualy_explode(num, indexes)
  sub_num = num
  indexes.each do |i|
    sub_num = sub_num[i] 
  end

  num = apply_explotion_left(num, indexes, sub_num[0])
  num = apply_explotion_right(num, indexes, sub_num[1])
  num = remove_sub_num(num, indexes)

  num
end

def explode_num(num, sub_num, indexes, performed_action)
  return [num, sub_num, indexes, performed_action] if performed_action
  sub_num.each_with_index do |sn, i|
    return [num, sub_num, indexes, performed_action] if performed_action

    if sn.is_a?(Array)
      indexes << i
      num, sub_num, indexes, performed_action = explode_num(num, sn, indexes, performed_action)
      indexes.pop
      next
    end

    return [num, sub_num, indexes, performed_action] if performed_action

    if indexes.length >= 4
      num = actualy_explode(num, indexes)
      performed_action = true

      return [num, sub_num, indexes, performed_action]
    end
  end

  [num, false]
end

def reduce_num(num)
  fully_reduced = false

  until fully_reduced
    performed_action = false
    sub_num = num
    indexes = []
    num, sub_num, indexes, performed_action = explode_num(num, sub_num, indexes, performed_action)

    next if performed_action

    num = split_number(num)

    fully_reduced = true
  end

  num
end

def solve_problem(snail_nums)
  num = reduce_num(snail_nums.first)
  snail_nums = snail_nums.drop(1)

  until snail_nums.empty?
    snail_nums, num = add_next_number(snail_nums, num)

    num = reduce_num(num)
  end
  # calculate_magnatude(num)
  num
end

# pp solve_problem(snail_nums)

