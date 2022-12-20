#!/usr/bin/ruby

class Challenge
  def process
    # Read input file
    input_filename = "day_2"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split("\n")
    
    @rps_points = {A: 1, B: 2, C: 3}
    @round_points = {X: 0, Y: 3, Z: 6}
    @hierarchy = {
      '0': {A: "C", B: "A", C: "B"},
      '3': {A: "A", B: "B", C: "C"},
      '6': {A: "B", B: "C", C: "A"}
    }

    @my_full_points = 0

    file_data.each {|row|
      row_arr = row.split(" ")
      elf_move = row_arr[0]
      round_end = row_arr[1]

      current_round_points = @round_points[round_end.to_sym]
      current_rps_points = @rps_points[@hierarchy[current_round_points.to_s.to_sym][elf_move.to_sym].to_sym]

      @my_full_points = @my_full_points + current_round_points + current_rps_points
    }

    return @my_full_points
  end
end