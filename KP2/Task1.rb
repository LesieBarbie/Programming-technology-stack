def apply_operation(numbers)

  unless block_given?
    raise ArgumentError, "Block is required"
  end

  numbers.map { |num| yield(num) }
end

numbers = [1, 2, 3, 4, 5]

result = apply_operation(numbers) { |n| n + 10 }
puts result.inspect


result = apply_operation(numbers) { |n| n**2 }
puts result.inspect

