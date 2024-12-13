# frozen_string_literal: true

class Plot
  attr_reader :x, :y, :name
  attr_accessor :zone, :fence_positions

  module FencePositions
    ALL = [
      TOP = "top",
      BOTTOM = "bottom",
      LEFT = "left",
      RIGHT = "right"
    ].freeze
  end

  def initialize(x,y,name)
    @x = x
    @y = y
    @name = name
    @zone = nil
    @fence_positions = []
  end

  def not_zoned?
    @zone.nil?
  end

  def has_zone?
    !@zone.nil?
  end

  def num_of_fences
    @fence_positions.size
  end
end

class Map
  def initialize(rows)
    @rows = rows
    @width = rows.first.count
    @height = rows.count
  end

  def zone_plots
    zone = 1
    until @rows.flatten.all?(&:has_zone?)
      plot = @rows.flatten.detect(&:not_zoned?)
      plot.zone = zone
      _look_around(plot)
      zone += 1
    end
  end

  def price_fence
    price = 0
    @rows.flatten.group_by(&:zone).each do |zone, plots|
      price += plots.size * _num_of_sides(plots)
    end
    price
  end

  private

  # @return [Integer]
  def _num_of_sides(plots)
    count = 0
    count += _count_side(plots, Plot::FencePositions::RIGHT,  false)
    count += _count_side(plots, Plot::FencePositions::LEFT,   false)
    count += _count_side(plots, Plot::FencePositions::TOP,    true)
    count += _count_side(plots, Plot::FencePositions::BOTTOM, true)
    count
  end

  # @return [Integer]
  def _count_side(plots, fence_position, is_left_right)
    subset = plots.select { |p| p.fence_positions.include?(fence_position) }

    # { x => [y, y], ... } OR { y => [x, x], ... }
    group = if is_left_right
              subset.group_by(&:y).transform_values { |p| p.map(&:x) }
            else
              subset.group_by(&:x).transform_values { |p| p.map(&:y) }
            end
    count = 0

    # count the number of "skipps" in the line
    group.each do |_key, line|
      line.each_with_index do |num, i|
        if i == 0 || num != (line[i - 1] + 1)
          count += 1
        end
      end
    end

    count
  end

  def _look_around(plot)
    _look(plot, plot.x + 1, plot.y    , Plot::FencePositions::RIGHT)
    _look(plot, plot.x - 1, plot.y    , Plot::FencePositions::LEFT)
    _look(plot, plot.x    , plot.y + 1, Plot::FencePositions::BOTTOM)
    _look(plot, plot.x    , plot.y - 1, Plot::FencePositions::TOP)
  end

  # either place the fence or add the new point to the zone and look around
  def _look(plot, x, y, fence_position)
    if _off_map?(x, y)
      plot.fence_positions << fence_position
      return
    end

    # don't zone the same plot twice (prevent infinate loop)
    other_plot = @rows[y][x]
    return if other_plot.zone == plot.zone

    if other_plot.name == plot.name
      other_plot.zone = plot.zone
      _look_around(other_plot)
      return
    end

    plot.fence_positions << fence_position
  end

  def _off_map?(x, y)
    return true if x < 0
    return true if y < 0
    return true if x >= @width
    return true if y >= @height
    false
  end
end

rows = []

file = '2024/day_12_guarden/input.txt'
f = File.open(file, "r")
f.each_line.with_index do |line, y|
  rows << line.strip.split('').each_with_index.map do |name, x|
    Plot.new(x, y, name)
  end
end

map = Map.new(rows)

map.zone_plots
pp map.price_fence