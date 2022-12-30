#!/usr/bin/ruby

class Challenge
  attr_accessor :patch
  
  def process
    # Read input file
    input_filename = "day_8"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split("\n")
    
    @patch = []
    
    file_data.each {|tree_line|
      @patch.push(tree_line.chars.map(&:to_i))
    }

    highest_scenic_score = 0
    
    @patch.each_with_index {|row_arr, row_nr|
      row_arr.each_with_index {|value, column_nr|
        current_scenic_score = get_scenic_score_for(row_nr, column_nr)
        if current_scenic_score > highest_scenic_score
          highest_scenic_score = current_scenic_score
        end
      }
    }

    return highest_scenic_score
  end
  
  def get_nr_of_seeable_trees_from(row, column, direction)
    result = 0
    current_height = @patch[row][column]
    
    case direction
    when "up"
      @patch.each_with_index {|row_heights, row_nr|
        if row_nr >= row
          break
        end
        
        if row_heights[column] >= current_height
          result = 1
        else
          result += 1
        end
      }
    when "down"
      @patch.each_with_index {|row_heights, row_nr|
        if row_nr <= row
          next
        end
        
        result += 1
        
        if row_heights[column] >= current_height
          break
        end
      }
    when "left"
      @patch[row].each_with_index {|tree_height, column_nr|
        if column_nr >= column
          break
        end
        
        if tree_height >= current_height
          result = 1
        else
          result += 1
        end
      }
    when "right"
      @patch[row].each_with_index {|tree_height, column_nr|
        if column_nr <= column
          next
        end
        
        result += 1
        
        if tree_height >= current_height
          break
        end
      }
    end
    
    return result
  end
  
  def get_scenic_score_for(row, column)
    # Tree is on the edge of the patch
    if row == 0 || column == 0 || row == @patch.length - 1 || column == @patch[0].length - 1
      return 0
    end
    
    current_tree_height = @patch[row][column]
    result = 1
    
    ["up", "right", "down", "left"].each {|direction|
      nr_of_trees = get_nr_of_seeable_trees_from(row, column, direction)
      
      if nr_of_trees == 0
        result = 0
        break
      end
      
      result *= nr_of_trees
    }
    
    return result
  end
end