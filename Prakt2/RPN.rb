def priority(operator)
  if operator == '+' || operator == '-'
    1
  elsif operator == '*' || operator == '/'
    2
  elsif operator == '^'
    3
  else
    0
  end
end

def convert_rpn(expression)
  result = []
  stack = []

  expression_space = expression.gsub(/([\+\-\*\/\^\(\)])/,' \1 ')
  elements = expression_space.split

  elements.each do |element|
    if element =~ /\w+/
      result.push(element)
    elsif element == '('
      stack.push(element)
    elsif element == ')'
      while stack.last != '('
        result.push(stack.pop)
      end
      stack.pop
    else
      while !stack.empty? && priority(stack.last) >= priority(element)
        result.push(stack.pop)
      end
      stack.push(element)
    end
  end

  while !stack.empty?
    result.push(stack.pop)
  end

  result.join(' ')
end

# Основний цикл для вводу виразів
loop do
  puts "Введіть математичний вираз (або 'exit' для виходу):"
  input = gets.chomp

  break if input.downcase == 'exit'  # Вихід з програми

  rpn = convert_rpn(input)
  puts "Вираз у RPN: #{rpn}"
end
