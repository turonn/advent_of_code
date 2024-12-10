class Chunk
  attr_reader :starting_index, :size
  include Comparable

  def initialize(starting_index, size, file_id = nil)
    @starting_index = starting_index
    @size = size # the physical distance it takes up
  end

  def count_chunk
    _count_chunk
  end

  def is_spacer?
    _is_spacer?
  end

  # @return [self]
  def reduce_size(size)
    _reduce_size(size)
  end

  # allows me to use "max" and "min"
  def <=>(other)
    @starting_index <=> other.starting_index
  end
end

# File is a core class
class Phile < Chunk
  attr_reader :file_id

  def initialize(starting_index, size, file_id = nil)
    @file_id = file_id || starting_index
    super
  end

  def update_starting_index(index)
    @starting_index = index
    self
  end

  private 

  # @return [Integer]
  def _count_chunk
    count = 0
    i = 0
    until i >= @size
      # file_id * position_in_stack
      count += (@file_id * (@starting_index + i))
      i += 1
    end

    count
  end

  def _reduce_size(size)
    @size -= size
    self
  end

  def _is_spacer?
    false
  end
end

class Spacer < Chunk
  private

  # we don't count spacers
  def _count_chunk
    0
  end

  def _reduce_size(size)
    @size -= size
    @starting_index += size
    self
  end

  def _is_spacer?
    true
  end
end

class Disk
  def initialize(files, spacers)
    @files = files.sort { |a, b| b <=> a }
    @spacers = spacers
  end

  def free_space
    @files.each do |file|
      _move_file(file)
    end
  end

  def checksum
    @files.sum(&:count_chunk)
  end

  private

  # @return [Boolean] true if the spacer is filled, false if it was not
  def _move_file(file)
    spacer = _earliest_viable_spacer(file)
    return false if spacer.nil?

    file = file.update_starting_index(spacer.starting_index)
    spacer = spacer.reduce_size(file.size)
    _remove_spacer(spacer) unless spacer.size > 0
    true
  end

  def _remove_spacer(spacer)
    @spacers.reject! { |s| s.is_spacer? && s.starting_index == spacer.starting_index && s.size == spacer.size }
  end

  # returns nil if a suitable spacer cannot be found
  def _earliest_viable_spacer(file)
    @spacers.sort.each do |spacer|
      return nil if spacer > file
      return spacer if spacer.size >= file.size
    end

    nil
  end
end

files = []
spacers = []

file = '2024/day_9_disk_map/input.txt'
f = File.open(file, "r")
f.each_line do |line|
  current_index = 0
  file_id = -1

  line.strip.split('').map(&:to_i).each_with_index do |size, i| # even indexes are files, odd are spacers
    next if size == 0
    if i.even?
      file_id += 1
      files << Phile.new(current_index, size, file_id)
    else
      spacers << Spacer.new(current_index, size)
    end
    current_index += size
  end
end

disk = Disk.new(files, spacers)

disk.free_space
pp disk.checksum

# 8705230292234 is too high