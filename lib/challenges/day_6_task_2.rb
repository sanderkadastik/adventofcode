#!/usr/bin/ruby

class Challenge
  def process
    # Read input file
    input_filename = "day_6"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).chars
    
    
    fourteen_letters = []
    counter = 0
    
    file_data.each {|char|
      if fourteen_letters.length < 14
        fourteen_letters.unshift(char)
        counter += 1
        next
      end
      
      if fourteen_letters.uniq.length == fourteen_letters.length
        break;
      end
      
      fourteen_letters.pop
      fourteen_letters.unshift(char)
      counter += 1
    }

    return counter
  end
end