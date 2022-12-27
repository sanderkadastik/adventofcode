#!/usr/bin/ruby

class Challenge
  def process
    # Read input file
    input_filename = "day_6"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).chars
    
    
    four_letters = []
    counter = 0
    
    file_data.each {|char|
      if four_letters.length < 4
        four_letters.unshift(char)
        counter += 1
        next
      end
      
      if four_letters.uniq.length == four_letters.length
        break;
      end
      
      four_letters.pop
      four_letters.unshift(char)
      counter += 1
    }

    return counter
  end
end