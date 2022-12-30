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

    counter = 0
    
    @patch.each_with_index {|row_arr, row_nr|
      row_arr.each_with_index {|value, column_nr|
        if has_none_or_only_smaller_trees_in_a_direction(row_nr, column_nr)
          counter += 1
        end
      }
    }

    return counter
  end
  
  def get_elements_from(row, column, direction)
    result = []
    
    case direction
    when "up"
      @patch.each_with_index {|row_heights, row_nr|
        if row_nr >= row
          break
        end
        
        result.push(row_heights[column])
      }
    when "down"
      @patch.each_with_index {|row_heights, row_nr|
        if row_nr <= row
          next
        end
        
        result.push(row_heights[column])
      }
    when "left"
      @patch[row].each_with_index {|tree_height, column_nr|
        if column_nr >= column
          break
        end
        
        result.push(tree_height)
      }
    when "right"
      @patch[row].each_with_index {|tree_height, column_nr|
        if column_nr <= column
          next
        end
        
        result.push(tree_height)
      }
    end
    
    return result
  end
  
  def has_none_or_only_smaller_trees_in_a_direction(row, column)
    # Tree is on the edge of the patch
    if row == 0 || column == 0 || row == @patch.length - 1 || column == @patch[0].length - 1
      return true
    end
    
    current_tree_height = @patch[row][column]
    result = false
    
    ["up", "right", "down", "left"].each {|direction|
      elements = get_elements_from(row, column, direction)
      if elements.max < current_tree_height
        result = true
        break
      end
    }
    
    return result
  end
end