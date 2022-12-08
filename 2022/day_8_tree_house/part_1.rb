class Tree
  attr_accessor :height, :left_vis, :right_vis, :up_vis, :down_vis

  def initialize(height:)
    @height = height
  end
end

def get_tree_grid_from_file(file)
  tree_grid = []
  f = File.open(file, "r")
  f.each_line do |line|
    tree_grid << line.strip.split('').each_with_index.map do |h, i|
      Tree.new(:height => h)
    end
  end

  tree_grid
end

def check_left_vis(tree_grid)
  tree_grid.each do |tree_row|
    max_height = 0
    tree_row.each_with_index do |tree, i|
      if i == 0
        max_height = tree.height
        tree.left_vis = true
        next
      end

      if tree.height > max_height
        max_height = tree.height
        tree.left_vis = true
      end
    end
  end

  tree_grid
end

def check_right_vis(tree_grid)
  tree_grid.each do |tree_row|
    max_height = 0
    tree_row.reverse.each_with_index do |tree, i|
      if i == 0
        max_height = tree.height
        tree.right_vis = true
        next
      end

      if tree.height > max_height
        max_height = tree.height
        tree.right_vis = true
      end
    end
  end

  tree_grid
end

def check_up_vis(tree_grid)
  column_indexs = tree_grid.first.length - 1
  (0..column_indexs).each do |column|
    max_height = 0

    tree_grid.each_with_index do |tree_row, row|
      if row == 0
        max_height = tree_row[column].height
        tree_row[column].up_vis = true
        next
      end

      if tree_row[column].height > max_height
        max_height = tree_row[column].height
        tree_row[column].up_vis = true
      end
    end
  end

  tree_grid
end

def check_down_vis(tree_grid)
  column_indexs = tree_grid.first.length - 1
  (0..column_indexs).each do |column|
    max_height = 0

    tree_grid.reverse.each_with_index do |tree_row, row|
      if row == 0
        max_height = tree_row[column].height
        tree_row[column].down_vis = true
        next
      end

      if tree_row[column].height > max_height
        max_height = tree_row[column].height
        tree_row[column].down_vis = true
      end
    end
  end

  tree_grid
end

file='2022/day_8/example.txt'
tree_grid = get_tree_grid_from_file(file)
tree_grid = check_left_vis(tree_grid)
tree_grid = check_right_vis(tree_grid)
tree_grid = check_up_vis(tree_grid)
tree_grid = check_down_vis(tree_grid)

puts tree_grid.flatten.select { |tree| tree.left_vis || tree.right_vis || tree.up_vis || tree.down_vis }.count
