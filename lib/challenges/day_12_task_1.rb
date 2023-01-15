#!/usr/bin/ruby

class Challenge
  
  # Static Variables
  @@controller
  
  # Constants
  INPUT_FILE_NAME = "day_12"

  
  def initialize
    @@controller = DijkstraController.new
  end
  
  def process
    process_file_data()
    @@controller.find_shortest_path()

    return @@controller.get_result()
  end
  
  def get_input_file_rows
    path_to_root = File.expand_path("..")

    return File.read(path_to_root + "/inputs/" + INPUT_FILE_NAME).split("\n")
  end
  
  def process_file_data
    matrix = []
    
    get_input_file_rows().each {|row|
      row = row.split("")
      
      if row.include? "S"
        @@controller.set_starting_position(matrix.length, row.find_index("S"))
        row[row.find_index("S")] = "a"
      end
      
      if row.include? "E"
        @@controller.set_ending_position(matrix.length, row.find_index("E"))
        row[row.find_index("E")] = "z"
      end
      
      matrix.push(row)
    }
    
    @@controller.set_heightmap(matrix)
  end
  
  
  def self.get_controller
    return @@controller
  end
end







class DijkstraController
  attr_reader :s_pos, :e_pos, :heightmap, :map_height, :map_width, :visited_map, :infinity, :current_pos, :paths
  @@a = 0
  def initialize
    @infinity = 99999
    @visited_map = []
    @paths = []
  end
  
  
  
  def set_starting_position(col, row)
    @s_pos = [col, row]
    @current_pos = [col, row]
  end
  
  def set_ending_position(col, row)
    @e_pos = [col, row]
  end
  
  def set_heightmap(map)
    @heightmap = map
    @map_height = @heightmap.length
    @map_width = @heightmap[0].length
    
    @map_height.times {
      row = []
      
      @map_width.times {
        row.push("+")
      }
      
      @visited_map.push(row)
    }
    
    @visited_map[@s_pos[0]][@s_pos[1]] = "v"
  end
  
  def mark_visited(col, row)
    @visited_map[col][row] = "v"
  end
  
  def is_node_visited(col, row)
    return @visited_map[col][row] === "v"
  end
  
  def get_surrounding_nodes_for(col, row)
    result = ["+", "+", "+", "+"]
    
    if col - 1 < 0
      result[0] = "-"
    elsif col + 1 > @map_height - 1
      result[2] = "-"
    end
    
    if row - 1 < 0
      result[3] = "-"
    elsif row + 1 > @map_width - 1
      result[1] = "-"
    end
    
    4.times {|i|
      next if result[i] === "-"
      
      case i
      when 0
        if @visited_map[col - 1][row] === "v"
          result[i] = "v"
        elsif @heightmap[col - 1][row].ord - @heightmap[col][row].ord > 1
          result[i] = "-"
        end
      when 1
        if @visited_map[col][row + 1] === "v"
          result[i] = "v"
        elsif @heightmap[col][row + 1].ord - @heightmap[col][row].ord > 1
          result[i] = "-"
        end
      when 2
        if @visited_map[col + 1][row] === "v"
          result[i] = "v"
        elsif @heightmap[col + 1][row].ord - @heightmap[col][row].ord > 1
          result[i] = "-"
        end
      when 3
        if @visited_map[col][row - 1] === "v"
          result[i] = "v"
        elsif @heightmap[col][row - 1].ord - @heightmap[col][row].ord > 1
          result[i] = "-"
        end
      end
    }
    
    return result
  end
  
  def has_any_path_reached_to_destination
    @paths.each {|path|
      if path.has_reached(@e_pos[0], @e_pos[1])
        return true
      end
    }
    
    return false
  end
  
  
  
  def find_shortest_path
    @paths.push(Path.new([@s_pos]))
    
    steps = 0
    
    until has_any_path_reached_to_destination() do
      next_step()
    end
  end
  
  def next_step()
    delete_paths = []
    new_paths = []
    @paths.each_with_index {|path, index|
      path.update_surrounding_nodes()

      if !path.has_available_steps()
        delete_paths.push(index)
        
        next
      end
      
      path.choose_next_step()
      path.generate_new_path_options().each {|new_path| new_paths.push(new_path)}
      path.finish_chosen_step()
    }
    
    # Remove blocked paths
    @paths.delete_if.with_index {|_, index|
      delete_paths.include? index
    }
    
    # Add new path possibilities
    new_paths.each{|path|
      @paths.push(path)
    }
  end
  
  
  
  def get_result()
    return @paths.first.get_steps_made()
  end
end



class Path
  attr_reader :current_node, :path, :surrounding_nodes, :next_node
  
  def initialize(path)
    @path = path
    @current_node = @path.last
  end
  
  def update_surrounding_nodes
    # Like ["Upper node", "Right node", "Bottom node", "Left Node"]
    # "v" - visited already (ignore)
    # "-" - movement is blocked (ignore)
    # "+" - can move there
    # "n" - next step for the current path
    
    @surrounding_nodes = Challenge.get_controller().get_surrounding_nodes_for(@current_node[0], @current_node[1])
  end
  
  def has_reached(col, row)
    return @path.last[0] === col && @path.last[1] === row
  end
  
  def has_available_steps
    return @surrounding_nodes.include?("+")
  end
  
  def get_steps_made
    return @path.length - 1
  end
  
  
  
  def choose_next_step
    @surrounding_nodes.each_with_index {|val, index|
      next if val != "+"
      
      case index
      when 0
        @next_node = [@current_node[0] - 1, @current_node[1]]
      when 1
        @next_node = [@current_node[0], @current_node[1] + 1]
      when 2
        @next_node = [@current_node[0] + 1, @current_node[1]]
      when 3
        @next_node = [@current_node[0], @current_node[1] - 1]
      end
    
      @surrounding_nodes[index] = "n"
      Challenge.get_controller().mark_visited(@next_node[0], @next_node[1])
      
      break
    }
  end
  
  def finish_chosen_step
    @path.push(@next_node)
    @current_node = @next_node
    @next_node = []
    @surrounding_nodes = []
  end
  
  
  
  def generate_new_path_options
    paths = []
    
    @surrounding_nodes.each_with_index {|val, index|
      next if val != "+"
      
      new_path = []
      @path.each {|node| new_path.push(node)}
      
      case index
      when 1
        new_path.push([@current_node[0], @current_node[1] + 1])
      when 2
        new_path.push([@current_node[0] + 1, @current_node[1]])
      when 3
        new_path.push([@current_node[0], @current_node[1] - 1])
      end
      
      path_obj = Path.new(new_path)
      
      paths.push(path_obj)
      
      Challenge.get_controller().mark_visited(path_obj.current_node[0], path_obj.current_node[1])
    }
    
    return paths
  end
end