#!/usr/bin/ruby

class Challenge
  def process
    # Read input file
    input_filename = "day_5"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split("\n")
    
    stacks = []
    last_row = ""
    file_data.each {|row|
      if row.strip == ""
        break
      end
      
      if last_row != ""
        stack_nr = 0
        
        last_row.chars.each_slice(4).to_a.each {|box_raw|
          if stacks[stack_nr].nil?
            stacks[stack_nr] = ""
          end
          
          stacks[stack_nr] = box_raw[1] + stacks[stack_nr]
          stack_nr += 1
        }
      end
      
      last_row = row
    }
    
    stacks.each_with_index {|stack, index|
      stacks[index] = stack.delete(" ").chars
    }
    
    is_instruction_part = false
    
    file_data.each {|instruction|
      if instruction.strip == ""
        is_instruction_part = true
        next
      elsif !is_instruction_part
        next
      end
      
      decoded_instruction = instruction.scan(/\d+/)
      
      decoded_instruction[0].to_i.times {
        from_stack = decoded_instruction[1].to_i - 1
        to_stack = decoded_instruction[2].to_i - 1
        
        stacks[to_stack].push(stacks[from_stack].pop)
      }
    }
    
    top_boxes = ""
    
    stacks.each {|stack|
      top_boxes += stack.pop
    }

    return top_boxes
  end
end