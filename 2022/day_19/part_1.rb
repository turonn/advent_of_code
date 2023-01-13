class Resources
  attr_reader :ore, :clay, :obsidean, :geode
  def initialize(ore, clay, obsidean, geode)
    @ore = ore
    @clay = clay
    @obsidean = obsidean
    @geode = geode
  end

  def >=(other)
    @ore >= other.ore && @clay >= other.clay && @obsidean >= other.obsidean && @geode >= other.geode
  end

  def -(other)
    Resources.new(
      @ore - other.ore,
      @clay - other.clay,
      @obsidean - other.obsidean,
      @geode - other.geode
    )
  end
end

# class Robot
#   attr_reader :type
#   attr_accessor :active
#   def initialize(type)
#     @type = type
#     @active = false
#   end
# end

class Blueprint
  attr_reader :num, :ore_robot_cost, :clay_robot_cost, :obsidean_cost, :geode_robot_cost
  def initialize(num, ore_robot_cost, clay_robot_cost, obsidean_cost, geode_robot_cost)
    @num = num
    @ore_robot_cost = ore_robot_cost
    @clay_robot_cost = clay_robot_cost
    @obsidean_cost = obsidean_cost
    @geode_robot_cost = geode_robot_cost
  end

  # @return [Boolean]
  def can_build?(robot, resources)
    case robot
    when "ore" then resources >= @ore_robot_cost
    when "clay" then resources >= @clay_robot_cost
    when "obsedian" then resources >= @obsedian_robot_cost
    when "geode" then resources >= @geode_robot_cost
    end
  end

  # @return [Resources]
  def build(robot, resources)
    case robot
    when "ore" then resources - @ore_robot_cost
    when "clay" then resources - @clay_robot_cost
    when "obsedian" then resources - @obsedian_robot_cost
    when "geode" then resources - @geode_robot_cost
    end
  end
end

class Account
  attr_reader :blueprint, :minutes_elapsed, :max_geodes, :resources_held, :robots_active, :robots_inactive

  def initialize(blueprint)
    @blueprint = blueprint
    @minutes_elapsed = 0
    @max_geodes = 0
    @resources_held = Resources.new(0,0,0,0)
    @robots_active = {ore: 1, clay: 0, obsedian: 0, geode: 0}
    @robots_inactive = {ore: 0, clay: 0, obsedian: 0, geode: 0}
  end

  def determine_max_geodes_in_given_time(max_time)
    while @minutes_elapsed < max_time
      _walk_branch
    end

    @max_geodes
  end

  private

  def _walk_branch
    _build_robots
    _collect_resources
    _activate_robots
  end
end

def read_file(file)
  blueprints = []

  f = File.open(file, "r")
  f.each_line do |line|
    arr = line.strip.split(':')
    num = arr[0].split(' ')[1].to_i

    cost_array = arr[1].split('.')
    ore_cost = cost_array[0].split(' ')[-2].to_i
    clay_cost = cost_array[1].split(' ')[-2].to_i
    obsedian_cost = [cost_array[2].split(' ')[-5].to_i, cost_array[2].split(' ')[-2].to_i]
    geode_cost = [cost_array[3].split(' ')[-5].to_i, cost_array[3].split(' ')[-2].to_i]

    blueprints << Blueprint.new(
      num,
      Resources.new(ore_cost, 0, 0, 0),
      Resources.new(clay_cost, 0, 0, 0),
      Resources.new(obsedian_cost[0], obsedian_cost[1], 0, 0),
      Resources.new(0, geode_cost[0], geode_cost[1], 0)
    )
  end

  blueprints
end

use_input = false
file = use_input ? '2022/day_19/input.txt' : '2022/day_19/example.txt'
blueprints = read_file(file)

puts blueprints