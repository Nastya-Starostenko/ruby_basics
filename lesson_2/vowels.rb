# 4. Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).

vowels = ('a'..'z').each_with_index.map { |word, index| index + 1 if word.match?(/[aeiou]/) }.compact
