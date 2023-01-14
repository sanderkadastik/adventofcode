#!/usr/bin/ruby

class Challenge
  # Variables
  attr_reader :new_monkey
  
  @@controller
  
  # Constants
  INPUT_FILE_NAME = "day_11"
  
  def initialize
    rounds = 20
    @@controller = KeepAwayController.new(rounds)
  end
  
  def process
    process_file_data()
    @@controller.play()

    return @@controller.get_result()
  end
  
  def get_input_file_rows
    path_to_root = File.expand_path("..")

    return File.read(path_to_root + "/inputs/" + INPUT_FILE_NAME).split("\n")
  end
  
  def process_file_data
    is_new_monkey_added = false
    
    get_input_file_rows().each {|row|
      row = row.strip
      
      if row.start_with?("Monkey ")
        row.slice! "Monkey "
        row.slice! ":"
        monkey_id = row.to_i
        
        @new_monkey = Monkey.new(monkey_id)
        is_new_monkey_added = false
      elsif row.start_with?("Starting items:")
        row.slice! "Starting items:"
        
        items = []
        row.gsub(" ", "").split(",").each {|worry_level|
          items.push(Item.new(worry_level.to_i))
        }
        
        @new_monkey.set_starting_items(items)
      elsif row.start_with?("Operation:")
        row.slice! "Operation: new ="
        
        @new_monkey.set_operation(row.strip)
      elsif row.start_with?("Test:")
        row.slice! "Test: divisible by"
        divisible_by = row.strip.to_i
        
        @new_monkey.set_test_divisible_by(divisible_by)
      elsif row.start_with?("If true:")
        row.slice! "If true: throw to monkey"
        monkey_id = row.strip.to_i
        
        @new_monkey.set_test_decision(true, monkey_id)
      elsif row.start_with?("If false:")
        row.slice! "If false: throw to monkey"
        monkey_id = row.strip.to_i
        
        @new_monkey.set_test_decision(false, monkey_id)
      else
        @@controller.add_new_monkey(@new_monkey)
        is_new_monkey_added = true
      end
    }
    
    if !is_new_monkey_added
      @@controller.add_new_monkey(@new_monkey)
      is_new_monkey_added = true
    end
  end
  
  def get_result
    return 0
  end
  
  
  def self.get_controller
    return @@controller
  end
end



class Monkey
  attr_reader :id, :items, :operation, :test_divisible_by, :test_true_monkey_id, :test_false_monkey_id, :inspection_count
  
  def initialize(id)
    @id = id
    @inspection_count = 0
  end
  
  def set_operation(operation)
    @operation = operation
  end
  
  def set_test_divisible_by(divisible_by)
    @test_divisible_by = divisible_by
  end
  
  def set_test_decision(decision, monkey_id)
    if decision
      @test_true_monkey_id = monkey_id
    else
      @test_false_monkey_id = monkey_id
    end
  end
  
  def set_starting_items(items)
    @items = items
  end
  
  
  
  def has_items
    return @items.length > 0
  end
  
  def process_next_item
    item = @items.shift()
    inspect_item(item)
    after_inspection_hook(item)
    throw_item(item)
  end
  
  def inspect_item(item)
    item.process_operation(@operation)
    @inspection_count += 1
  end
  
  def after_inspection_hook(item)
    item.divide_worry_level_by(3)
  end
  
  def throw_item(item)
    if item.is_divisible_by(@test_divisible_by)
      Challenge.get_controller().throw_item_to_monkey_id(item, @test_true_monkey_id)
    else
      Challenge.get_controller().throw_item_to_monkey_id(item, @test_false_monkey_id)
    end
  end
  
  
  def catch_item(item)
    @items.push(item)
  end
end



class Item
  attr_reader :worry_level
  
  def initialize(worry_level)
    @worry_level = worry_level
  end
  
  def divide_worry_level_by(n)
    @worry_level /=  n.to_f
    round_worry_level_down()
  end
  
  def round_worry_level_down
    @worry_level = @worry_level.floor.to_i
  end
  
  def is_divisible_by(n)
    return @worry_level % n == 0
  end
  
  def process_operation(operation)
    @worry_level = eval(operation.gsub("old", @worry_level.to_s)).to_i
  end
end



class KeepAwayController
  attr_reader :monkeys, :rounds
  
  def initialize(rounds)
    @rounds = rounds
    @monkeys = []
  end

  def play
    @rounds.times {
      @monkeys.each {|monkey|
        while monkey.has_items()
          monkey.process_next_item()
        end
      }
    }
  end
  
  def get_result
    most = 0
    second = 0
    
    @monkeys.each {|monkey|
      if most < monkey.inspection_count
        second = most
        most = monkey.inspection_count
      elsif second < monkey.inspection_count
        second = monkey.inspection_count
      end
    }
    
    return most * second
  end
  
  
  
  def throw_item_to_monkey_id(item, monkey_id)
    get_monkey_with_id(monkey_id).catch_item(item)
  end
  
  def get_monkey_with_id(monkey_id)
    return (@monkeys.select { |monkey| monkey.id == monkey_id }).first()
  end
  
  
  
  def add_new_monkey(monkey)
    @monkeys.push(monkey)
  end
end