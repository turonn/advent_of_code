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
  def initialize(chunks)
    @chunks = chunks
  end

  def free_space
    while true
      return unless _fill_spacer(_earliest_spacer)
    end
  end

  def checksum
    @chunks.sum(&:count_chunk)
  end

  private

  # @return [Boolean] true if the spacer is filled, false if it was not
  def _fill_spacer(spacer)
    while true
      latest_file = _latest_file

      # don't fill the spacer if the file is before the spacer
      return false if latest_file < spacer

      if spacer.size <= latest_file.size
        @chunks << Phile.new(spacer.starting_index, spacer.size, latest_file.file_id)
        # requires specail attention because it's in the middle of the array
        _remove_spacer(spacer)
        
        # if there is no more remainder, delete the old file
        latest_file = latest_file.reduce_size(spacer.size)
        @chunks.delete(latest_file) unless latest_file.size > 0

        return true
      else
        @chunks << Phile.new(spacer.starting_index, latest_file.size, latest_file.file_id)
        @chunks.delete(latest_file)

        # no clue why modifying means you have to re add it
        spacer = spacer.reduce_size(latest_file.size)
      end
    end
  end

  def _remove_spacer(spacer)
    @chunks.reject! { |c| c.is_spacer? && c.starting_index == spacer.starting_index && c.size == spacer.size }
  end

  def _earliest_spacer
    @chunks.filter_map { |c| c.is_spacer? ? c : nil }.min
  end

  def _latest_file
    @chunks.filter_map { |c| c.is_spacer? ? nil : c }.max
  end
end

chunks = []

file = '2024/day_9_disk_map/example.txt'
f = File.open(file, "r")
f.each_line do |line|
  current_index = 0
  file_id = -1

  line.strip.split('').map(&:to_i).each_with_index do |size, i| # even indexes are files, odd are spacers
    next if size == 0
    chunks << if i.even?
                file_id += 1
                Phile.new(current_index, size, file_id)
              else
                Spacer.new(current_index, size)
              end
    current_index += size
  end
end

disk = Disk.new(chunks)

disk.free_space
pp disk.checksum