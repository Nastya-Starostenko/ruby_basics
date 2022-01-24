# 5. Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
 # Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.
 # (Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?)
 # Алгоритм опредления високосного года: docs.microsoft.com

input = { year: nil, month: nil, day: nil }

input.each do |key, value|
  puts "Put #{key} (numbers only)"
  input[key] = gets.chomp.to_i
end

return puts '!!!! Your date is incorrect !!!!' if input.values.any? 0

months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

leap_year = (input[:year] % 4 == 0 && input[:year] % 100 != 0) || (input[:year] % 400 == 0)
days_in_year = leap_year ? 366 : 365

months[1] = 29 if leap_year

day_of_the_year = input[:month] == 1 ? input[:day] : months[0..input[:month]-2].sum + input[:day]

puts "The day of the year is #{day_of_the_year}"
