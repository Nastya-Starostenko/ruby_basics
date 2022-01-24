product_cart = {}

loop do
  puts "For exit input - stop"
  input = []
  ["Input product name", "Input product price", "Input product count" ].each do |text|
    puts text
    input << gets.chomp

    break if input.last == 'stop'
  end
  break if input.last == 'stop'

  product_cart[input.first] = { price: input[1].to_f , count: input.last.to_f }
  total_price = product_cart.values.map {|a| a[:price] }.sum

  puts '!!!!!!!!!!!!!!!!!!!!!!'
  product_cart.each {|k,v| puts "Product: #{k}, price: #{v[:price]}, count: #{v[:count]}, sum: #{v[:count] * v[:price]}}" }
  puts "Total price: #{total_price}"
  puts '!!!!!!!!!!!!!!!!!!!!!!'
end
