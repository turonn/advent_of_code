# frozen_string_literal: true

class Towel
  module Colors
    ALL = [
      WHITE = 'w', 
      BLUE = 'u', 
      BLACK = 'b',
      RED = 'r',
      GREEN = 'g'
    ]
  end

  # @param stripes [String]
  def initialize(stripes)
    @stripes = stripes
  end

  def is_single_color?
    @stripes.count == 1
  end

  # @param other_towels [Array<Towel>]
  def can_be_made_from_subset?(other_towels)
    valid_towels = other_towels.reject { |ot|  }

  end

  # @return [Array<Char>]
  def _colors_in_self
    @stripes.chars.to_set.to_a
  end

  # @return [Array<Char>]
  def _colors_not_in_self
    Colors::ALL - _colors_in_self
  end
end

class Design
  # @param pattern [String]
  def initialize(pattern)
    @pattern = pattern
  end
end

towels = []
designs = []

File.open('2024/day_19_towels/example.txt', "r").each_with_index do |line, i|
  if i == 0
    towels = line.strip.split(' ').map { |s| Towel.new(s.chomp(',')) }
    next
  end
  next if i == 1

  designs << Design.new(line.strip)
end


# looking at the input, I see many single color towels. If a second towel is made up of colors we have a s singles, it's not useful to us.

single_colored_towels = towels.select(&:is_single_color?)

ignorable_towels = towels.reject { |t| t.can_be_made_from_subset?(single_colored_towels) }

important_towels = towels.select { |t| }

# we can also ignore all towels made up of signles that we already own.

# we can make subsets of the towels for each color, towels_containing_black, towels_containing_white, etc


# 


pp towels
pp designs