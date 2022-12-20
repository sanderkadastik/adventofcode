#!/usr/bin/ruby

puts "Which day's challenge would you like to see? [1/2]"
day = gets.chomp

if day != "2"
  puts "Which challenge of the day would you like to see? [1/2]"
  task_nr = gets.chomp
else
  task_nr = "1"
end

require "./challenges/day_" + day + "_task_" + task_nr + ".rb"

challenge = Challenge.new
puts challenge.process