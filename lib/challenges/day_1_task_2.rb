#!/usr/bin/ruby

class Challenge
  def process
    # Read input file
    input_filename = "day_1"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split(/^\n+/)
    
    # Calculate and retrieve the number of most calories by elf
    @first_calories = 0
    @second_calories = 0
    @third_calories = 0
    
    file_data.each {|calories_str|
      single_elf_calories = 0
      calories = calories_str.split("\n")
      
      calories.each {|single_calories|
        single_elf_calories = single_elf_calories + single_calories.to_i
      }

      if @third_calories > single_elf_calories
        next
      end

      if @first_calories < single_elf_calories
        @third_calories = @second_calories
        @second_calories = @first_calories
        @first_calories = single_elf_calories
      elsif @second_calories < single_elf_calories
        @third_calories = @second_calories
        @second_calories = single_elf_calories
      elsif @third_calories < single_elf_calories
        @third_calories = single_elf_calories
      end
    }

    return @first_calories + @second_calories + @third_calories
  end
end