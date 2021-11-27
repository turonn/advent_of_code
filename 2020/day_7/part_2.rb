file='2020/day_7/input.txt'
bag_rules = {}
inside_sgb = ['shiny gold bag']

def strip_space_and_s(arr)
  arr.map do |value|
    nv = value.strip
    if value[-1] == 's'
      nv = nv[0..-2]
    end
    nv
  end
end

f = File.open(file, "r")
f.each_line do |line|
  arr = line.strip.split('s contain ')
  next if arr[1] == 'no other bags.'

  key = arr[0]
  values = arr[1].tr('0-9.', '').split(',')

  bags = strip_space_and_s(values)

  bag_rules[key] = bags
end

previous_size = 0

while inside_sgb > 0
  old_inside_sgb = inside_sgb
  old_bag_rules
  inside_sgb = []

  old_inside_sgb.each do |bag|
    bag_rules.delete(bag)
    old_bag_rules = bag_rules
    old_bag_rules.each do |k, v|
      if v.include?(bag)
        inside_sgb << k
        bag_rules.delete(k)
      end
    end
  end
end

puts lead_to_sgb.count - 1