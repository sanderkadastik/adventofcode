#!/usr/bin/ruby

class Challenge
  attr_accessor :cycle, :sprite_positionr, :rows, :current_row, :row_length
  
  def process
    # Read input file
    input_filename = "day_10"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split("\n")
    
    
    @row_length = 40
    @current_row = 0
    @rows = [[]]
    
    @cycle = 1
    @sprite_position = 1
    
    file_data.each {|instruction|
      #p "Begin instruction: " + instruction
      run_instruction(instruction)
      #p "End instruction"
      #p "----------"
    }

    #p signal_strengths.inspect
    #p signal_strengths.sum
    
    answer = "--- BEGIN ---\n"

    @rows.each {|row|
      answer += row.join + "\n"
    }
    
    answer += "---- END ----"

    return answer
  end
  

  
  def run_instruction(instruction)
    instruction_arr = instruction.split
    
    case instruction_arr[0]
    when "noop"
      # Nothing happens, only 1 cycle
      next_cycle
    when "addx"
      2.times {
        next_cycle
      }
      
      @sprite_position += instruction_arr[1].to_i
    end
  end
  
  def next_cycle
    if @rows[@current_row].nil?
      @rows.push([])
    end
    
    if are_sprite_and_cycle_overlapping
      #p "Cycle: " + @cycle.to_s
      #p "CPU Register: " + @cpu_register.to_s
      #p "Signal strength: " + (@cycle * @cpu_register).to_s
      
      @rows[@current_row].push("#")
    else
      @rows[@current_row].push(".")
    end
    
    @cycle += 1
    
    # Move to the next row
    if @rows[@current_row].length == @row_length
      @cycle = 1
      @current_row += 1
    end
  end
  
  def are_sprite_and_cycle_overlapping
    return (@cycle).between?(@sprite_position, @sprite_position + 2)
  end
end