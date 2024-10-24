def remove_duplicates(array)
  array.uniq
end

def count_vowels(string)
  vowels = %w[a e i o u A E I O U а е є и і ї о у ю я А Е Є И І Ї О У Ю Я а е ё и о у ы э ю я А Е Ё И О У Ы Э Ю Я і]
  string.chars.count { |char| vowels.include?(char) }
end

def menu
  puts "Виберіть опцію:"
  puts "1. Видалити дублікати з масиву"
  puts "2. Обчислити кількість голосних у рядку"
  puts "0. Вихід"
end

loop do
  menu
  choice = gets.chomp.to_i

  case choice
  when 1
    puts "Введіть масив через пробіл:"
    array = gets.chomp.split
    result = remove_duplicates(array)
    puts "Масив без дублікатів: #{result.inspect}"
  when 2
    puts "Введіть рядок:"
    string = gets.chomp
    result = count_vowels(string)
    puts "Кількість голосних: #{result}"
  when 0
    puts "Вихід з програми."
    break
  else
    puts "Неправильний вибір. Спробуйте знову."
  end
end
