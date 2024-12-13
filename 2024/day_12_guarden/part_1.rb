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
      price += plots.size * plots.sum(&:num_of_fences)
    end
    price
  end

  private

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