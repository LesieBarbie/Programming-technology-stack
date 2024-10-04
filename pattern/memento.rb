class Originator
  attr_accessor :state

  def initialize(state)
    @state = state
    puts "Ініціалізований стан творця: #{@state}"
  end

  def do_something(new_state = nil)
    puts "Якісь дії творця"
    @state = new_state
  end

  def save
    ConcreteMemento.new(@state)
  end

  def restore(memento)
    @state = memento.state
    puts "Значення творця змінено на: #{@state}"
  end

  def get_state
    @state
  end
end

class Memento
  def name
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def date
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class ConcreteMemento < Memento
  def initialize(state)
    @state = state
    @date = Time.now.strftime('%F %T')
  end
  attr_reader :state
  def name
    "#{@date} / (#{@state[0, 9]}...)"
  end
  attr_reader :date
end

class Caretaker
  def initialize(originator)
    @mementos = []
    @originator = originator
  end

  def backup
    puts "\nОпікун зберігає стан творця..."
    @mementos << @originator.save
  end

  def undo
    return if @mementos.empty?

    memento = @mementos.pop
    puts "Опікун повертає стан: #{memento.name}"

    begin
      @originator.restore(memento)
    rescue StandardError
      undo
    end
  end

  def show_history
    puts 'Список знімків:'
    @mementos.each { |memento| puts memento.name }
  end
end

originator = Originator.new('Найпочатковіший стан')
caretaker = Caretaker.new(originator)

loop do
  puts "\nВведіть новий стан (або 'exit' для виходу):"
  input = gets.chomp
  break if input.downcase == 'exit'

  caretaker.backup
  originator.do_something(input)

  puts "Стан після дій: #{originator.get_state}"

  puts "\nВведіть 'undo' для повернення до попереднього знімка, 'history' для перегляду історії або 'continue' для продовження:"
  command = gets.chomp

  case command.downcase
  when 'undo'
    caretaker.undo
  when 'history'
    caretaker.show_history
  when 'continue'
    next
  else
    puts "Невідома команда!"
  end
end

puts "Програма завершена."
