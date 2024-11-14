def priority(operator)
  case operator
  when '+', '-' then 1
  when '*', '/' then 2
  when '^' then 3
  else 0
  end
end

def convert_rpn(expression)
  result = []
  stack = []
  expression_space = expression.gsub(/([+\-*\/^()])/,' \1 ').gsub(/\s+/, ' ')
  elements = expression_space.split
  last_token = nil

  elements.each_with_index do |element, index|
    if element =~ /^-?\d+(\.\d+)?$/ || (element =~ /^[a-zA-Z]+$/ && last_token != ')') # Числа або змінні
      result.push(element)
    elsif element == '-' && (last_token.nil? || last_token =~ /[\+\-\*\/\(\^]/)
      # Унарний мінус: перетворюємо його на від'ємне число
      number = "-#{elements[index + 1]}"
      result.push(number)
      elements[index + 1] = '' # Пропустити наступний елемент
    elsif element == '('
      stack.push(element)
    elsif element == ')'
      while stack.any? && stack.last != '('
        result.push(stack.pop)
      end
      if stack.empty?
        raise "Невірне використання дужок: зайва закриваюча дужка"
      end
      stack.pop # Видаляємо відкриваючу дужку
    else
      while !stack.empty? && priority(stack.last) >= priority(element) && stack.last != '('
        result.push(stack.pop)
      end
      stack.push(element)
    end
    last_token = element
  end

  while !stack.empty?
    if stack.last == '('
      raise "Невірне використання дужок: зайва відкрита дужка"
    end
    result.push(stack.pop)
  end

  result.join(' ')
end

def evaluate_rpn(rpn_expression)
  stack = []

  rpn_expression.split.each do |token|
    if token =~ /^-?\d+(\.\d+)?$/
      stack.push(token.to_f)
    else
      b = stack.pop
      a = stack.pop
      case token
      when '+'
        stack.push(a + b)
      when '-'
        stack.push(a - b)
      when '*'
        stack.push(a * b)
      when '/'
        raise " ділення на 0" if b == 0
        stack.push(a / b)
      when '^'
        stack.push(a**b)
      else
        raise "Невідомий оператор: #{token}"
      end
    end
  end

  raise " зайві операнди" if stack.size != 1
  stack.pop
end

loop do
  puts "Введіть математичний вираз (або 'exit' для виходу):"
  input = gets.chomp

  break if input.downcase == 'exit'

  begin
    rpn = convert_rpn(input)
    puts "Вираз у RPN: #{rpn}"
    result = evaluate_rpn(rpn)
    puts "Результат обчислення: #{result}"
  rescue => e
    puts "Помилка: #{e.message}"
  end
end
