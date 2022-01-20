puts 'Give me, please, three coefficient'

coefficient = []
3.times do
  puts 'Give coefficient'
  coefficient << gets.chomp.to_i
end

d = (coefficient[1] ** 2.0 - 4 * coefficient[0] * coefficient[2])

if d > 0
  х_one = ( -coefficient[1] + Math.sqrt(d) ) / ( 2 * coefficient[0])
  x_two = ( -coefficient[1] - Math.sqrt(d) ) / ( 2 * coefficient[0])
  puts "d = #{d},  x1 = #{х_one},  x2 = #{x_two}"
elsif d == 0
  х_one = (–coefficient[1])/( 2 * coefficient[0])
  puts "d = #{d}, x1 = #{х_one}"
else
  puts "d = #{d}, no roots"
end
