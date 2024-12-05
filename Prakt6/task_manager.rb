# frozen_string_literal: true

require 'json'
require 'date'

class TaskManager
  attr_accessor :tasks

  def initialize(file = 'tasks.json')
    @file = file
    @tasks = load_tasks
  end

  def add_task(title, deadline)
    return unless valid_date?(deadline)

    formatted_deadline = Date.parse(deadline).strftime('%d.%m.%Y') # Форматування дати
    @tasks << { id: next_id, title: title, deadline: formatted_deadline, status: 'incomplete' }
    save_tasks
  end

  def delete_task(id)
    @tasks.reject! { |task| task[:id] == id }
    save_tasks
  end

  def edit_task(id, title: nil, deadline: nil, status: nil)
    found_task = @tasks.find { |task| task[:id] == id }
    return unless found_task

    found_task[:title] = title if title
    if deadline && valid_date?(deadline)
      found_task[:deadline] = Date.parse(deadline).strftime('%d.%m.%Y')
    end
    found_task[:status] = status if status
    save_tasks
  end

  def filter_tasks(status: nil, before: nil)
    filtered = @tasks
    filtered = filtered.select { |task| task[:status] == status } if status
    if before && valid_date?(before)
      formatted_before = Date.parse(before).strftime('%d.%m.%Y')
      filtered = filtered.select { |task| Date.strptime(task[:deadline], '%d.%m.%Y') < Date.strptime(formatted_before, '%d.%m.%Y') }
    end
    filtered
  end

  def save_tasks
    File.write(@file, JSON.pretty_generate(@tasks))
  end

  private

  def load_tasks
    return [] unless File.exist?(@file)

    JSON.parse(File.read(@file), symbolize_names: true)
  end

  def next_id
    (@tasks.map { |task| task[:id] }.max || 0) + 1
  end

  def valid_date?(date)
    Date.parse(date)
    true
  rescue ArgumentError
    false
  end
end

# CLI
def main
  manager = TaskManager.new

  loop do
    puts "\n==== TASK MANAGER ===="
    puts "1. Add Task"
    puts "2. Delete Task"
    puts "3. Edit Task"
    puts "4. Filter Tasks"
    puts "5. Show All Tasks"
    puts "6. Exit"
    print "Choose an option: "

    choice = gets.chomp.to_i

    case choice
    when 1
      print "Enter task title: "
      title = gets.chomp
      print "Enter task deadline (DD.MM.YYYY): "
      deadline = gets.chomp
      if valid_date?(deadline)
        manager.add_task(title, deadline)
        puts "\n✅ Task added successfully!"
      else
        puts "\n❌ Invalid date format. Please try again."
      end
    when 2
      print "Enter task ID to delete: "
      id = gets.chomp.to_i
      if manager.tasks.any? { |task| task[:id] == id }
        manager.delete_task(id)
        puts "\n✅ Task deleted successfully!"
      else
        puts "\n❌ Task not found."
      end
    when 3
      print "Enter task ID to edit: "
      id = gets.chomp.to_i
      if manager.tasks.any? { |task| task[:id] == id }
        print "Enter new title (or press Enter to skip): "
        title = gets.chomp
        title = nil if title.empty?
        print "Enter new deadline (DD.MM.YYYY, or press Enter to skip): "
        deadline = gets.chomp
        deadline = nil if deadline.empty? || !valid_date?(deadline)
        print "Enter new status (incomplete/complete, or press Enter to skip): "
        status = gets.chomp
        status = nil if status.empty?
        manager.edit_task(id, title: title, deadline: deadline, status: status)
        puts "\n✅ Task updated successfully!"
      else
        puts "\n❌ Task not found."
      end
    when 4
      print "Filter by status (incomplete/complete, or press Enter to skip): "
      status = gets.chomp
      status = nil if status.empty?
      print "Filter by deadline before (DD.MM.YYYY, or press Enter to skip): "
      before = gets.chomp
      before = before.empty? ? nil : before
      filtered = manager.filter_tasks(status: status, before: before)
      if filtered.empty?
        puts "\n❌ No tasks found."
      else
        display_tasks(filtered)
      end
    when 5
      if manager.tasks.empty?
        puts "\n❌ No tasks available."
      else
        display_tasks(manager.tasks)
      end
    when 6
      puts "\n👋 Goodbye!"
      break
    else
      puts "\n❌ Invalid option. Try again."
    end
  end
end

def display_tasks(tasks)
  puts "\n==== TASK LIST ===="
  puts format("%-4s | %-20s | %-12s | %-10s", "ID", "Title", "Deadline", "Status")
  puts "-" * 50
  tasks.each do |task|
    puts format("%-4d | %-20s | %-12s | %-10s", task[:id], task[:title], task[:deadline], task[:status])
  end
end

def valid_date?(date)
  Date.parse(date)
  true
rescue ArgumentError
  false
end

if __FILE__ == $0
  main
end
