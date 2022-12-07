Directory = Struct.new(:name, :parent, :children, :filesize, keyword_init: true)

def parse_lines(file)
  f = File.open(file, "r")
  root_directory = current_dir = Directory.new(:name => 'root', :parent => '', :children => [], :filesize => 0)
  directories = [current_dir]
  f.each_line do |line|
    li = line.strip.split(' ')
  
    if li[0] == '$'
      case li[1]
      when 'cd'
        case li[2]
        when '/'
          current_dir = root_directory
        when '..'
          current_dir = current_dir.parent
        else
          current_dir = current_dir.children.detect { |dir| dir.name == li[2] }
        end
      when 'ls'
        next
      end
    else
      if li[0] == 'dir'
        new_directory = Directory.new(name: li[1], parent: current_dir, children: [], filesize: 0)
        current_dir.children << new_directory
        directories << new_directory
      else
        current_dir.filesize += li[0].to_i
      end
    end
  end

  directories
end

def find_true_file_size(directory)
  filesize = directory.filesize
  directory.children.each do |dir|
    if dir.children.empty?
      filesize += dir.filesize
    else
      filesize += find_true_file_size(dir)
    end
  end

  filesize
end

file='2022/day_7/input.txt'
directories = parse_lines(file)

root_size = find_true_file_size(directories.detect { |dir| dir.name == 'root' })
free_space = 70000000 - root_size
space_needed = 30000000 - free_space 

directory_sizes = directories.map { |directory| find_true_file_size(directory) }
big_enough_directories = directory_sizes.reject { |dir| dir < space_needed }
puts big_enough_directories.min
