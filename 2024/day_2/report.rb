class Report
  @@all ||= []

  INCREASING = "increasing".freeze
  DECREASING = "decreasing".freeze

  def initialize(levels)
    @levels = levels

    @@all << self
  end

  def self.all
    @@all
  end

  def is_safe?
    direction = "" 
    @levels.each_with_index do |level, i|
      next if i == 0
      prior_level = @levels[i-1]
      return false if _large_jump_or_static?(level, prior_level)

      if direction == ""
        direction = _set_direction(level, prior_level)
        next
      end

      if direction == INCREASING
        return false if level < prior_level
        next
      end

      return false if level > prior_level
    end

    true
  end

  private

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