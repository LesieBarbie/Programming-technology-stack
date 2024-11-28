numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


chunks = numbers.each_slice((numbers.size / 2.0).ceil).to_a

worker = Ractor.new do
  chunk = Ractor.receive

  chunk.map { |n| n * 2 }
end

worker.send(chunks[0])

main_result = chunks[1].map { |n| n * 2 }

worker_result = worker.take

final_result = worker_result + main_result

puts "Оброблений масив: #{final_result.inspect}"
