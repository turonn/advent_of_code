file='2020/day_7/example.txt'
all_bags = {}

def strip_space_and_s(arr)
  arr.map do |value|
    nv = value.strip
    if value[-1] == 's'
      nv = nv[0..-2]
    end
    nv
  end
end

def turn_into_hash(bags_array)
  hash = {}
  bags_array.each do |bag|
    num_of_bags = bag[0]
    type_of_bag = bag[2..-1]
    hash[type_of_bag] = num_of_bags
  end
  hash
end

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split('s contain ')
  outer_bag = arr[0]
  
  if arr[1] == 'no other bags.'
    inner_bags_hash = {}
  else
    inner_bags_array = strip_space_and_s(arr[1].tr('.', '').split(','))
    inner_bags_hash = turn_into_hash(bags_array)
  end
  all_bags[outer_bag] = inner_bags_hash
end

# {
#   outer1 : {
#     inner1 : num,
#     inner2 : num
#   },
#   inner1 : {
#   },
#   inner2 : {
#     inner3 : num,
#     inner4 : num
#   },
#   inner3 : {}
# }

def bags_inside_given_bag(all_bags, bag)
  if all_bags.key?(bag)
    all_bags[bag]
  end
end

small_hash = { 'shiny gold bag': 1 }
count = 0


small_hash.each do |bag, num|
  if all_bags.key?(bag)
    working_array << num
    search_inner_bag(bag)
  else

  end
end