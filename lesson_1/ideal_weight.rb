puts 'Give your name'
name = gets.chomp

puts 'Give your height'
height = gets.chomp.to_i

ideal_weight = (height - 110) * 1.15
puts "#{name}, your weight already ideal!" if ideal_weight < 0
