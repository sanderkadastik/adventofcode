#!/usr/bin/ruby

class Challenge
  attr_accessor :rope, :tail_history
  
  def process
    # Read input file
    input_filename = "day_9"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split("\n")
    
    
    @rope = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
    @tail_history = [[0, 0]]
    
      
    step = 1 # 1 for up/right, -1 for left/down
    axis_pos = 0 # 0 for x, 1 for y
    
    file_data.each {|line|
      line_arr = line.split
      
      case line_arr[0]
      when "U"
        step = 1
        axis_pos = 1
      when "R"
        step = 1
        axis_pos = 0
      when "D"
        step = -1
        axis_pos = 1
      when "L"
        step = -1
        axis_pos = 0
      end
      
      line_arr[1].to_i.times {
        @rope[0][axis_pos] += step
        
        @rope.each_with_index {|knot, index|
          if index == 0
            next
          end
      
          # Knot moves
          if (@rope[index - 1][0] - knot[0]).abs > 1 || (@rope[index - 1][1] - knot[1]).abs > 1
          
            # Knot moves on Y-axis
            if @rope[index - 1][0] == knot[0]
              if @rope[index - 1][1] - knot[1] > 0
                knot[1] += 1
              else
                knot[1] -= 1
              end
            
              # Knot moves on X-axis
            elsif @rope[index - 1][1] == knot[1]
              if @rope[index - 1][0] - knot[0] > 0
                knot[0] += 1
              else
                knot[0] -= 1
              end
            
              # Knot moves on both
            else
              if @rope[index - 1][1] - knot[1] > 0
                knot[1] += 1
              else
                knot[1] -= 1
              end
            
              if @rope[index - 1][0] - knot[0] > 0
                knot[0] += 1
              else
                knot[0] -= 1
              end
            end
          end
          
          # Tail is in new position
          if index == 9 && !@tail_history.include?(knot)
            @tail_history.push([knot[0], knot[1]])
          end
        }
      }
    }

    return @tail_history.length
  end
end