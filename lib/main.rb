#!/usr/bin/ruby

puts "Which day's challenge would you like to see? [1-12]"
day = gets.chomp

puts "Which challenge of the day would you like to see? [1/2]"
task_nr = gets.chomp

require "./challenges/day_" + day + "_task_" + task_nr + ".rb"

challenge = Challenge.new
puts ""
puts "And the answer is..."
puts challenge.process