#!/usr/bin/ruby

class Challenge
  def process
    # Read input file
    input_filename = "day_7"
    path_to_root = File.expand_path("..")
    file_data = File.read(path_to_root + "/inputs/" + input_filename).split("\n")
    
    
    file_system = FileSystem.new
    
    # Read in rows from file
    file_data.each {|row|
      file_system.process_row(row)
    }
    if !file_system.current_command.is_finished
      file_system.current_command.run(file_system)
    end

    # Calculate directory sizes
    file_system.calculate_directory_sizes

    # Get the final answer
    return file_system.smallest_dir_to_open_up_space_of(30000000, 70000000)
  end
end



class FileSystem
  attr_accessor :current_command
  attr_reader :directories
  
  @cwd_str
  
  @cwd = []
  
  def initialize
    @directories = {}
    change_directory("/")
  end
  
  def change_directory(to)
    if to == "/"
      @cwd = ["/"]
    elsif to == ".."
      if @cwd.length > 1
        @cwd.pop
      end
    else
      @cwd.push(to)
    end
    
    @cwd_str = get_cwd_as_string
    
    if !@directories.key?(@cwd_str)
      parent = nil
      
      if (@cwd.length > 1)
        parent_wd = @cwd.map(&:clone)
        parent_wd.pop
        parent_wd_str = parent_wd.join("/").sub("//", "/")
        
        if !@directories.key?(parent_wd_str)
          abort("Directory \"" + parent_wd_str + "\" does not exist. It cannot become a parent directory!")
        end
        
        parent = @directories[parent_wd_str]
      end
      
      @directories[@cwd_str] = Directory.new(@cwd.last, parent)
    end
  end
  
  def get_cwd_as_string
    return @cwd.join("/").sub("//", "/")
  end
  
  
  def process_row(row)
    
    # Command
    if row.start_with?("$")
      if !@current_command.nil? && @current_command.has_response && !@current_command.is_finished
        @current_command.run(self)
      end
      
      @current_command = Command.new(row)
      
      if !@current_command.has_response
        @current_command.run(self)
      end
      
      return
    end
    
    # Everything else
    if @current_command.has_response && !@current_command.is_finished
      @current_command.add_row_to_response(row)
    end
  end
  
  def calculate_directory_sizes
    while @directories["/"].final_size.nil?
      @directories.each {|path, dir|
        
        # Already calculated. Next.
        if (!dir.final_size.nil?)
          next
        end
        
        all_inner_dirs_are_calculated = true
        
        dir.directories.each {|file_name, file_size|
          if file_size.nil?
            all_inner_dirs_are_calculated = false
            break
          end
        }
  
        # Some of the children size have not been calculated yet.
        if !all_inner_dirs_are_calculated
          next
        end
        
        final_size = dir.directories.values.sum + dir.files.values.sum
        dir.final_size = final_size
        
        if !dir.parent.nil?
          dir.parent.directories[dir.full_path_to_directory] = final_size
        end
      }
    end
  end
  
  def sum_of_dirs_equal_to_or_smaller_than(size)
    total_size_of_small_dirs = 0
    
    @directories.each {|path, dir|
      if (dir.final_size <= size)
        total_size_of_small_dirs += dir.final_size
      end
    }
    
    return total_size_of_small_dirs
  end
  
  def smallest_dir_to_open_up_space_of(needed_size, disk_size)
    currently_used = @directories["/"].final_size
    empty_space_on_disk = disk_size - currently_used
    needs_to_be_deleted = needed_size - empty_space_on_disk
    
    current_candidate = @directories["/"].final_size
    
    @directories.each {|path, dir|
      if dir.final_size >= needs_to_be_deleted && dir.final_size < current_candidate
        current_candidate = dir.final_size
      end
    }
    
    return current_candidate
  end
  
  
  
  def add_child_link_to_cwd(dir_name)
    full_path = (@cwd_str + "/" + dir_name).sub("//", "/")
    @directories[@cwd_str].add_child(full_path)
  end
  
  def add_file_to_cwd(file_name, file_size)
    @directories[@cwd_str].add_file(file_name, file_size)
  end
end




class Directory
  attr_accessor :final_size
  attr_reader :name, :full_path_to_directory, :parent, :files, :directories
  
  def initialize(dir_name, parent_dir = nil)
    @files = {}
    @directories = {}
    @name = dir_name
    @parent = parent_dir
    @final_size = nil
    
    if parent_dir.nil?
      @full_path_to_directory = @name.sub("//", "/")
    else
      @full_path_to_directory = (parent_dir.full_path_to_directory + "/" + @name).sub("//", "/")
    end
  end
  
  
  def has_file(file_name)
    return @files.key? file_name
  end
  
  def add_file(file_name, file_size)
    if !has_file(file_name)
      @files[file_name] = file_size
    end
  end


  def has_child(full_path_to_dir)
    return @directories.key? full_path_to_dir
  end
  
  def add_child(full_path_to_dir)
    if !has_child(full_path_to_dir)
      @directories[full_path_to_dir] = nil
    end
  end
  
  
  def is_root
    return @parent.nil?
  end
end



class Command
  attr_reader :name, :parameter, :response, :has_response, :is_finished
  
  @@allowed_command_names = ["cd", "ls"]
    
  
  def initialize(row)
    cmd = row.split
    
    if cmd[0] != "$"
      abort("\"" + cmd[0] + "\" is not a beginning of a command!")
    end
    
    if (!@@allowed_command_names.include? cmd[1])
      abort("Command name \"" + cmd[1] + "\" is not allowed!")
    end
    
    @name = cmd[1]
    
    case @name
    when "cd"
      if cmd.length != 3
        abort("The \"cd\" command should have 3 components. " + cmd.length.to_s + " given...")
      end
      
      @parameter = cmd[2]
      @has_response = false
    when "ls"
      @has_response = true
      @response = []
    end
    
    @is_finished = false
  end
  
  
  def run(file_system)
    if @name == "cd"
      file_system.change_directory(@parameter)
      @is_finished = true
    elsif @name == "ls"
      @response.each {|row|
        components = row.split
        
        if components[0] == "dir"
          if (components.length != 2)
            abort("TOO MANY ROWS (should be 2)! - " + components.length.to_s)
          end
          
          file_system.add_child_link_to_cwd(components[1])
        else
          if (components.length != 2)
            abort("TOO MANY ROWS (should be 2)! - " + components.length.to_s)
          end
          
          file_system.add_file_to_cwd(components[1], components[0].to_i)
        end
      }
      
      @is_finished = true
    end
  end
  
  
  def add_row_to_response(row)
    @response.push(row)
  end
end
