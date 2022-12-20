#!/usr/bin/ruby

class Challenge
  def process
    # Read input file
    input_filename = "day_2"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split("\n")
    
    @elf_points = {A: 1, B: 2, C: 3}
    @my_points = {X: 1, Y: 2, Z: 3}
    @points_map = {
      AX: 3, AY: 6, AZ: 0,
      BX: 0, BY: 3, BZ: 6,
      CX: 6, CY: 0, CZ: 3
    }
    
    @my_full_points = 0
    
    file_data.each {|row|
      row_arr = row.split(" ")
      elf_move = row_arr[0]
      my_move = row_arr[1]
      
      current_move = elf_move + my_move
      
      @my_full_points = @my_full_points + @my_points[my_move.to_sym] + @points_map[current_move.to_sym]
    }

    return @my_full_points
  end
end