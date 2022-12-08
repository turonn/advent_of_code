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
    tree_row.each_with_index do |tree, i|      
      visable_trees = 0
      comparison_tree_index = i - 1

      until comparison_tree_index < 0
        visable_trees += 1

        break if tree.height <= tree_row[comparison_tree_index].height
        comparison_tree_index -= 1
      end

      tree.left_vis = visable_trees
    end
  end

  tree_grid
end

def check_right_vis(tree_grid)
  tree_grid.each do |tree_row|
    tree_row.reverse.each_with_index do |tree, i|      
      visable_trees = 0
      comparison_tree_index = i - 1
      
      until comparison_tree_index < 0
        visable_trees += 1

        break if tree.height <= tree_row.reverse[comparison_tree_index].height
        comparison_tree_index -= 1
      end

      tree.right_vis = visable_trees
    end
  end

  tree_grid
end

def check_up_vis(tree_grid)
  column_indexs = tree_grid.first.length - 1
  (0..column_indexs).each do |column|
    tree_grid.each_with_index do |tree_row, row|
      visable_trees = 0
      comparison_tree_index = row - 1

      until comparison_tree_index < 0
        visable_trees += 1

        break if tree_row[column].height <= tree_grid[comparison_tree_index][column].height
        comparison_tree_index -= 1
      end

      tree_row[column].up_vis = visable_trees
    end
  end

  tree_grid
end

def check_down_vis(tree_grid)
  column_indexs = tree_grid.first.length - 1
  (0..column_indexs).each do |column|
    tree_grid.reverse.each_with_index do |tree_row, row|
      visable_trees = 0
      comparison_tree_index = row - 1

      until comparison_tree_index < 0
        visable_trees += 1

        break if tree_row[column].height <= tree_grid.reverse[comparison_tree_index][column].height
        comparison_tree_index -= 1
      end

      tree_row[column].down_vis = visable_trees
    end
  end

  tree_grid
end

def score_tree_grid(tree_grid)
  tree_grid.flatten.map { |tree| tree.left_vis * tree.right_vis * tree.up_vis * tree.down_vis }
end

file='2022/day_8/input.txt'
tree_grid = get_tree_grid_from_file(file)
tree_grid = check_left_vis(tree_grid)
tree_grid = check_right_vis(tree_grid)
tree_grid = check_up_vis(tree_grid)
tree_grid = check_down_vis(tree_grid)

scores = score_tree_grid(tree_grid)
puts scores.max
