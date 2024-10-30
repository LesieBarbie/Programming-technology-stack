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
  expression_space = expression.gsub(/([+\-*\/^()])/,' \1 ')
  elements = expression_space.split
  last_token = nil

  elements.each_with_index do |element, index|
    if element =~ /^-?\d+(\.\d+)?$/ || (element == '-' && (last_token.nil? || %w[+ - * / (].include?(last_token)))
      # Перевірка на унарний мінус як частину числа
      if element == '-' && (last_token.nil? || %w[+ - * / (].include?(last_token))
        number = "-#{elements[index + 1]}"
        result.push(number)
        elements[index + 1] = ''  # Уникнемо повторної обробки числа
      else
        result.push(element)
      end
    elsif element == '('
      stack.push(element)
    elsif element == ')'
      while stack.last != '('
        raise "Невірне використання дужок" if stack.empty?
        result.push(stack.pop)
      end
      stack.pop
    else
      # Перевірка на зайві оператори підряд
      if element =~ /[+\-*\/^]/ && %w[+ - * / ^ (].include?(last_token)
        raise " зайвий оператор '#{element}'"
      end

      # Перевірка на зайвий оператор в кінці виразу
      if index == elements.size - 1 && element =~ /[+\-*\/^]/
        raise " вираз закінчується оператором '#{element}'"
      end

      # Обробка операторів за пріоритетом
      while !stack.empty? && priority(stack.last) >= priority(element)
        result.push(stack.pop)
      end
      stack.push(element)
    end
    last_token = element
  end

  # Витягуємо всі оператори зі стеку
  while !stack.empty?
    raise " зайва дужка" if stack.last == '(' || stack.last == ')'
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
