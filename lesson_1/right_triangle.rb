puts 'Give me, please, three side of triangle'

sides = []
3.times do
  puts 'Give side'
  sides << gets.chomp.to_i
end

two_sides_equal = sides.map { |a| sides.count(a) >= 2 }
three_sides_equal = sides.map { |a| sides.count(a) == 3 }
pythagoras = sides.sort.reverse.map {|a| a**2 }

if pythagoras.first == pythagoras[1..2].sum
  puts 'Triangle is rectangular.'
elsif three_sides_equal.any?(true)
  puts 'Triangle is equilateral and isosceles'
elsif   two_sides_equal.any?(true)
  puts 'Triangle is isosceles'
end
