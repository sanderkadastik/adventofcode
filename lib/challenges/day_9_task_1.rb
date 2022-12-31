#!/usr/bin/ruby

class Challenge
  attr_accessor :head_x, :head_y, :tail_x, :tail_y, :tail_history
  
  def process
    # Read input file
    input_filename = "day_9"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split("\n")
    
    
    @head_x = 0
    @head_y = 0
    
    @tail_x = 0
    @tail_y = 0
    
    @tail_history = [[@tail_x, @tail_y]]
    
      
    step = 1 # 1 for up/right, -1 for left/down
    axis = "x" # 0 for x, 1 for y
    
    file_data.each {|line|
      line_arr = line.split
      
      case line_arr[0]
      when "U"
        step = 1
        axis = "y"
      when "R"
        step = 1
        axis = "x"
      when "D"
        step = -1
        axis = "y"
      when "L"
        step = -1
        axis = "x"
      end
      
      line_arr[1].to_i.times {
        instance_variable_set("@head_" + axis, instance_variable_get("@head_" + axis) + step)
        
        # Tail moves
        if (@head_x - @tail_x).abs > 1 || (@head_y - @tail_y).abs > 1
          
          # Tail moves on Y-axis
          if @head_x == @tail_x
            if @head_y - @tail_y > 0
              @tail_y += 1
            else
              @tail_y -= 1
            end
            
          # Tail moves on X-axis
          elsif @head_y == @tail_y
            if @head_x - @tail_x > 0
              @tail_x += 1
            else
              @tail_x -= 1
            end
            
          # Tail moves on both
          else
            if @head_y - @tail_y > 0
              @tail_y += 1
            else
              @tail_y -= 1
            end
            
            if @head_x - @tail_x > 0
              @tail_x += 1
            else
              @tail_x -= 1
            end
          end
        end
        
        tail_pos = [@tail_x, @tail_y]
        
        if !@tail_history.include?(tail_pos)
          @tail_history.push(tail_pos)
        end
      }
    }

    return @tail_history.length
  end
end