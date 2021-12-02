class Bag
  attr_accessor :name, :bags_inside, :all
  @@all = {}
  @@total_count = 0
  @@running_array = []

  def initialize(name, bags_inside)
    @name = name
    @bags_inside = bags_inside
    
    @@all[@name] = @bags_inside
  end

  def self.all
    @@all
  end

  def self.total_count(starting_bag)
    _add_to_array_and_find_inner_bags(starting_bag)
    @@total_count - 1
  end

  def self._add_to_array_and_find_inner_bags(bag)
    bag_key = bag.keys[0].to_s
    bag_count = bag.values[0].to_i

    return unless @@all.key?(bag_key)

    @@running_array << bag_count
    _add_to_total
    _find_inner_bags(bag_key)
  end

  def self._find_inner_bags(bag_key)
    inner_bags = @@all[bag_key] 
    unless inner_bags.empty?
      inner_bags.each do |k, v|
        _add_to_array_and_find_inner_bags({k => v})
      end
      _remove_from_array
    else
      _remove_from_array
    end
  end

  def self._add_to_total
    @@total_count += @@running_array.inject(:*)
  end

  def self._remove_from_array
    @@running_array = @@running_array[0..-2]
  end
end