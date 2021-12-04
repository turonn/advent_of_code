require 'active_support/core_ext/string/filters'
file='2021/day_4/example.txt'
random_numbers = []
bingo_board = []
all_bingo_boards = []
row = 0

first_line = true
f = File.open(file, "r")
f.each_line do |line|
  if first_line
    random_numbers = line.strip.split(',')
    first_line = false

  elsif line.strip.empty?
    all_bingo_boards << bingo_board
    bingo_board = []
    row = 0

  else
    line.squish.split(' ').each_with_index do |num, index|
      bingo_number_hash = {}
      bingo_number_hash[:row] = row
      bingo_number_hash[:column] = index
      bingo_number_hash[:value] = num.to_i
      bingo_number_hash[:called] = false

      bingo_board << bingo_number_hash
    end

    row += 1
  end
end
all_bingo_boards << bingo_board
all_bingo_boards = all_bingo_boards.drop(1)

def flip_numbers_in_bingo_boards(all_bingo_boards, pulled_num)
  all_bingo_boards.each do |bingo_board|
    bingo_board.each do |num_hash|
      num_hash[:called] = true if num_hash[:value] == pulled_num
    end
  end
  all_bingo_boards
end

def check_board_rows_or_columns(bingo_board, row_column)
  [0,1,2,3,4].each do |row|
    flipped_in_row = bingo_board.select { |num_hash| (num_hash[:called] == true) && (num_hash[row_column] == row) }

    return bingo_board if flipped_in_row.size == 5
  end
  []
end

def check_boards_for_winner(all_bingo_boards)
  winning_boards = []

  all_bingo_boards.each_with_index do |bingo_board, index|
    winning_board = check_board_rows_or_columns(bingo_board, :row)
    winning_boards << winning_board if winning_board.size > 0
    
    winning_board = check_board_rows_or_columns(bingo_board, :column)
    winning_boards << winning_board if winning_board.size > 0
  end

  winning_boards
end

def get_winning_board_and_last_called(all_bingo_boards, random_numbers)
  winning_boards = []
  random_numbers.each do |pulled_num|
    all_bingo_boards = flip_numbers_in_bingo_boards(all_bingo_boards, pulled_num.to_i)
    winning_boards = check_boards_for_winner(all_bingo_boards)

    unless winning_boards.empty?
      all_bingo_boards = all_bingo_boards - winning_boards
      
      if all_bingo_boards.empty?
        return [winning_boards.first, pulled_num.to_i]
      end
    end
  end
end

def sum_of_unmarked_numbers_times_last_called(array)
  winning_board = array[0]
  last_called_number = array[1]
  sum = 0

  winning_board.each do |num_hash| 
    sum += num_hash[:value] if num_hash[:called] == false 
  end

  sum * last_called_number
end

answer = sum_of_unmarked_numbers_times_last_called(get_winning_board_and_last_called(all_bingo_boards, random_numbers))

puts answer