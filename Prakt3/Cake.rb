def split_cake(cake, raisin_char)
  rows = cake.size
  cols = cake[0].size

  # Збираємо координати всіх родзинок
  raisins = []
  cake.each_with_index do |row, r|
    row.chars.each_with_index do |char, c|
      raisins << [r, c] if char == raisin_char
    end
  end
  puts "Координати родзинок: #{raisins}"

  n = raisins.size
  return [] if n < 2 || n >= 10

  total_area = rows * cols
  piece_area = total_area / n
  return [] if total_area % n != 0

  puts "Розміри пирога: #{rows}x#{cols}"
  puts "Загальна площа: #{total_area}, Площа одного шматка: #{piece_area}"

  # Функція для створення шматка з координатами
  def get_region(cake, start_r, start_c, height, width)
    (start_r...(start_r + height)).map do |r|
      cake[r][start_c...(start_c + width)]
    end
  end

  # Генерація всіх валідних шматків для кожної родзинки
  def find_split(cake, raisins, piece_area, raisin_char)
    regions = []
    rows = cake.size
    cols = cake[0].size

    raisins.each_with_index do |(r, c), idx|
      puts "Розглядаємо родзинку #{idx + 1} на координатах (#{r}, #{c})"
      (1..rows).each do |height|
        next if piece_area % height != 0
        width = piece_area / height
        next if width > cols

        (0..(rows - height)).each do |start_r|
          (0..(cols - width)).each do |start_c|
            region = get_region(cake, start_r, start_c, height, width)
            if region.join.count(raisin_char) == 1
              regions << { region: region, start_r: start_r, start_c: start_c, height: height, width: width, raisin: [r, c] }
            end
          end
        end
      end
    end
    regions
  end

  # Перевірка, чи всі шматки покривають різні області
  def valid_solution?(solution)
    occupied_cells = []
    solution.each do |piece|
      cells = []
      piece[:region].each_with_index do |row, r|
        row.chars.each_with_index do |cell, c|
          cells << [piece[:start_r] + r, piece[:start_c] + c]
        end
      end
      return false if (occupied_cells & cells).any?
      occupied_cells.concat(cells)
    end
    true
  end

  # Алгоритм пошуку розбиття
  def solve(available_regions, raisins, raisin_char)
    combinations = available_regions.group_by { |reg| reg[:raisin] }
    combinations.values[0].product(*combinations.values[1..]).each do |combo|
      next unless combo.size == raisins.size
      return combo if valid_solution?(combo)
    end
    []
  end

  regions = find_split(cake, raisins, piece_area, raisin_char)
  result = solve(regions, raisins, raisin_char)

  result.empty? ? [] : result.map { |r| r[:region] }
end

# Тестова функція
def test_cake
  raisin_char = 'о'

  puts "Enter a number of rows in the matrix (pie):"
  rows = gets.chomp.to_i

  if rows <= 0
    puts "ERROR! Invalid input. Number of rows should be greater than 0."
    return
  end

  cake = []
  puts "Enter a Raisin pie (matrix) line by line:"
  rows.times { cake << gets.chomp }

  result = split_cake(cake, raisin_char)
  if result.empty?
    puts "Result of split a Raisin pie: []"
  else
    puts "Result of split a Raisin pie:"
    result.each_with_index do |region, idx|
      puts "Шматок #{idx + 1}:"
      puts region.join("\n")
    end
  end
end

test_cake
