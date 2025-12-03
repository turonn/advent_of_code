class Bank
  # @param bank [Array<Integer>]
  def initialize(bank)
    @bank = bank
    @last_index = bank.length - 1
  end

  def largest_joltage
    largest_battery_candidates = _largest_battery_candidates(
      forbidden_indices: [@last_index]
    )
    # the battery farthest to the left of the largest size is the only one we care about
    largest_battery = largest_battery_candidates.min_by { |b| b[:index] }

    second_largest_batteries = _largest_battery_candidates(
      forbidden_indices: largest_battery[:index].downto(0)
    )
    # It can be an arbitrary battery of the same value
    second_largest_battery = second_largest_batteries.first

    largest_battery[:value] * 10 + second_largest_battery[:value]
  end

  private

  # @param forbidden_indices [Array<Integer>] the indices that are invalid for use
  # @return [Array<Hash>] #value: Integer, index: Integer
  def _largest_battery_candidates(forbidden_indices:)
    9.downto(1).each do |size|
      batteries = _batteries_of_size(size)
      batteries = batteries.reject { |b| forbidden_indices.include?(b[:index]) }
      next if batteries.empty?

      return batteries
    end
  end

  # @return [Array<Hash>] #value: Integer, index: Integer
  def _batteries_of_size(size)
    @bank.each_with_index.filter_map do |value, index|
      next unless value == size
      { value:, index: }
    end
  end
end


joltages = []

File.open('2025/day_3/input.txt', "r").each_line do |line|
  bank = Bank.new(line.strip.split('').map(&:to_i))
  joltages << bank.largest_joltage
end

puts joltages.sum
