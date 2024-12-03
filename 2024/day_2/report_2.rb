class Report
  @@all = []
  @@safe = []
  @@unsafe = []

  INCREASING = "increasing".freeze
  DECREASING = "decreasing".freeze

  def initialize(levels, first_pass)
    @levels = levels
    @first_pass = first_pass

    @@all << self if first_pass
  end

  def self.all
    @@all
  end

  def is_safe?
    direction = "" 
    @levels.each_with_index do |level, i|
      next if i == 0
      prior_level = @levels[i-1]
      return _unsafe if _large_jump_or_static?(level, prior_level)

      if direction == ""
        direction = _set_direction(level, prior_level)
        next
      end

      if direction == INCREASING
        return _unsafe if level < prior_level
        next
      end

      return _unsafe if level > prior_level
    end

    @@safe << self
    true
  end

  # @return [Boolean]
  def safe_with_dampener?
    permutations = (0...@levels.size).map { |i| @levels.dup }
    permutations = permutations.each_with_index.map do |permutation, index|
      permutation.delete_at(index)
      Report.new(permutation, false)
    end

    permutations.each do |permutation|
      return true if permutation.is_safe?
    end

    false
  end

  private

  def _unsafe
    @@unsafe << self if @first_pass
    false
  end

  def _large_jump_or_static?(level, prior_level)
    return true if level == prior_level
    (level - prior_level).abs > 3
  end

  def _set_direction(level, prior_level)
    if level > prior_level
      INCREASING
    else
      DECREASING
    end
  end
end