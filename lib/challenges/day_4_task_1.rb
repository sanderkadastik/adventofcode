#!/usr/bin/ruby

class Challenge
  def process
    # Read input file
    input_filename = "day_4"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split("\n")
    
    
    @full_overlap_count = 0
    
    file_data.each {|pair|
      first_sections_min = pair.split(",")[0].split("-")[0].to_i
      first_sections_max = pair.split(",")[0].split("-")[1].to_i
      second_sections_min = pair.split(",")[1].split("-")[0].to_i
      second_sections_max = pair.split(",")[1].split("-")[1].to_i
      
      if (first_sections_min >= second_sections_min && first_sections_max <= second_sections_max) || (first_sections_min <= second_sections_min && first_sections_max >= second_sections_max)
        @full_overlap_count += 1
      end
    }

    return @full_overlap_count
  end
end