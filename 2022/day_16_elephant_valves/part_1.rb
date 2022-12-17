class Valve
  attr_accessor :is_released, :edges, :edge_indexes
  attr_reader :name, :index, :flow_rate, :edge_names

  def initialize(name, index, flow_rate, edge_names)
    @name = name
    @index = index
    @flow_rate = flow_rate
    @edge_names = edge_names
    @is_released = false
    Valve.all << self
  end

  def distance_from_other_index(other_index)
    @@floyd_matrix[@index][other_index]
  end

  def self.all
    @@all ||= []
  end

  def self.find(name)
    @@all.detect { |valve| valve.name == name }
  end

  def self.find_by_index(index)
    @@all.detect { |valve| valve.index == index }
  end

  def self.index_edges
    Valve.all.each do |valve|
      valve.edge_indexes = valve.edge_names.map { |edge_name| Valve.find(edge_name).index }
    end
  end

  def self.starting_valve
    @@starting_valve ||= Valve.find('AA')
  end

  def self.generate_floyd_matrix
    matrix = _generate_base_matrix
    rows = matrix.size

    rows.times do |k|
      rows.times do |i|
        rows.times do |j|
          current_val = matrix[i][j]
          perspective_val = matrix[i][k] + matrix[k][j]

          matrix[i][j] = perspective_val if perspective_val < current_val
        end
      end
    end

    @@floyd_matrix = matrix
  end

  def self.floyd_matrix
    @@floyd_matrix
  end

  def self.valves_of_interest
    @@valves_of_interest ||= Valve.all
                                  .select { |valve| valve.flow_rate.positive? }
                                  .reject { |valve| valve == Valve.starting_valve }
  end

  def self.max_pressure_released
    @@max_pressure_released ||= 0
  end

  def self.score_path_and_consider_for_max(path)
    contending_max = path.map { |step| step[:flow_rate] * step[:minutes_open] }.sum

    @@max_pressure_released = [Valve.max_pressure_released, contending_max].max
  end

  def self.viable_paths
    @@viable_paths ||= []
  end

  def self.generate_viable_paths
    start_index = Valve.starting_valve.index
    flow_rate = Valve.starting_valve.flow_rate
    minutes_open = flow_rate.positive? ? 29 : 30
    _look_around(
      [{
        index: start_index,
        flow_rate: flow_rate,
        minutes_open: minutes_open
      }],
      Valve.valves_of_interest.reject { |v| v == Valve.starting_valve }
    )
  end

  private

  def self._look_around(current_path, unexamined_valves)
    potential_valves = _potential_next_valves(current_path.last, unexamined_valves)

    potential_valves.each do |valve|
      new_path, new_valves = _step_to_valve(current_path, potential_valves, valve)
      _look_around(new_path, new_valves)
    end

    Valve.viable_paths << current_path
  end

  def self._step_to_valve(current_path, potential_valves, valve)
    time_to_get_there = valve.distance_from_other_index(current_path.last[:index])
    time_remaining = current_path.last[:minutes_open]

    new_step = {
      index: valve.index,
      flow_rate: valve.flow_rate,
      minutes_open: time_remaining - time_to_get_there - 1
    }
    new_valves = potential_valves.reject { |v| v == valve }

    [current_path.dup.append(new_step), new_valves]
  end

  def self._potential_next_valves(current_step, unexamined_valves)
    minutes_remaining = current_step[:minutes_open]
    unexamined_valves.select do |valve|
      valve.distance_from_other_index(current_step[:index]) < (minutes_remaining - 1)
    end
  end

  def self._generate_base_matrix
    matrix_size = Valve.all.size
    blank_row = Array.new(matrix_size, Float::INFINITY)

    Valve.all.sort_by(&:index).map do |valve|
      row = blank_row.clone
      valve.edge_indexes.each { |index| row[index] = 1 }
      row[valve.index] = 0

      row
    end
  end
end

def read_file(file)
  index = 0
  f = File.open(file, 'r')
  f.each_line do |line|
    arr = line.strip.split(' ')
    name = arr[1]
    flow_rate = arr[4].split('=')[1].delete(';').to_i
    edge_names = arr[9..-1].map { |v| v.include?(',') ? v.delete(',') : v }

    Valve.new(name, index, flow_rate, edge_names)
    index += 1
  end
end

use_input = true
file = use_input ? '2022/day_16/input.txt' : '2022/day_16/example.txt'
read_file(file)

Valve.index_edges
Valve.generate_floyd_matrix
Valve.generate_viable_paths

Valve.viable_paths.each do |path|
  Valve.score_path_and_consider_for_max(path)
end

Valve.floyd_matrix.each { |r| puts r.join(',') }

puts Valve.max_pressure_released
