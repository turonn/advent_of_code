class Bank
  # @param bank [Array<Integer>]
  def initialize(bank)
    @bank = bank
    @last_index = bank.length - 1
  end

  def largest_joltage
    batteries = []
    # the largest battery will be rank 11, the smallest rank 0. I'll use the rank to think of the invalid indices on the
    # right side of the bank
    11.downto(0).map do |battery_rank|
      forbidden_indices = battery_rank.times.map { |i| @last_index - i }
      unless batteries.empty?
        forbidden_indices = forbidden_indices + batteries.last[:index].downto(0).to_a
      end
      batteries << _best_largest_valid_battery(forbidden_indices:)
    end

    batteries.map { |b| b[:value] }.join('').to_i
  end

  private

  # @param forbidden_indices [Array<Integer>] the indices that are invalid for use
  # @return [Hash] #value: Integer, index: Integer
  def _best_largest_valid_battery(forbidden_indices:)
    9.downto(1).each do |size|
      batteries = _batteries_of_size(size)
      batteries = batteries.reject { |b| forbidden_indices.include?(b[:index]) }
      next if batteries.empty?

      return batteries.min_by { |b| b[:index] }
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
