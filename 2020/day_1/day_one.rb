array = ARGF.readlines
answer = []

while answer == []
  num_3_array = []
  num_2 = nil
  num_1 = array.first.to_i
  array = array.drop(1)
  array2 = array

  array.each do |value|
    # array2.delete(value)
    num_2 = value.to_i
    puts num_2

    num_3_array = array2.select { |num_3| (num_3.to_i + num_1 + num_2) == 2020 }

    unless num_3_array.empty?
      answer << num_1
      answer << num_2
      answer << num_3_array.first.to_i
      puts answer.inject(:*)
    end

    break if !num_3_array.empty?
  end
end

