require_relative 'Todo'
require_relative 'todoRepository'
require_relative '../due/due'
require 'colorize'
require 'tabulate'
require 'colorized_string'
require 'time'

module Todo
  # Todo controller provides the menu options and commandline outputs and inputs for todos
  class TodoController

    def self.add_todo
      puts '-- Add a Todo! --'.yellow
      new_todo = nil
      new_todo = construct_todo(new_todo)
      begin
        todo_repo = TodoRepository.new_with_data_from(File.expand_path('../../data/data.json', File.dirname(__FILE__)))
        todo_repo.add(new_todo)
        todo_repo.save_todos_to_file
        puts '** Todo Added! **'.green
      rescue => e
        puts "Error: #{e.message}"
      end
    end

    def self.construct_todo(new_todo)
      todo_values = { 'title' => nil, 'for_when' => nil, 'alert_mins' => nil, 'alert_type' => nil }
      input_todo_values(todo_values)
      while new_todo.equal? nil
        begin
          input_todo_values(todo_values)
          new_todo = Todo.new_todo(-1, todo_values['title'], todo_values['for_when'], todo_values['alert_mins'], todo_values['alert_type'], false)
        rescue => e
          puts "Error: #{e.message}"
        end
      end
      new_todo
    end

    def self.input_todo_values(todo_values)
      todo_values['title'] = enter_title if todo_values['title'].equal? nil
      todo_values['for_when'] = enter_for_when if todo_values['for_when'].equal? nil
      todo_values['alert_mins'] = enter_alert_mins if todo_values['alert_mins'].equal? nil
      todo_values['alert_type'] = enter_alert_type if todo_values['alert_type'].equal? nil
    end

    def self.all_todos
      todo_repo = TodoRepository.new_with_data_from(File.expand_path('../../data/data.json', File.dirname(__FILE__)))
      puts '-- All Todos! --'.yellow
      puts '** No todos! **'.red if todo_repo.count.zero?
      
      todos_to_table(todo_repo.todos_all)
    end

    def self.pending_todos
      todo_repo = TodoRepository.new_with_data_from(File.expand_path('../../data/data.json', File.dirname(__FILE__)))
      puts '-- Pending Todos! --'.yellow
      puts '** No pending todos! **'.red if todo_repo.count.zero? || todo_repo.todos_pending.count.zero?

      todos_to_table(todo_repo.todos_pending)
    end

    def self.complete_todo
      begin
        todo_repo = TodoRepository.new_with_data_from(File.expand_path('../../data/data.json', File.dirname(__FILE__)))
        puts '-- Complete a Todo! --'.yellow
        id_of_todo_to_complete = enter_id('complete')
        todo_to_complete = todo_repo.todo_by_id(id_of_todo_to_complete)

        if todo_to_complete.nil?
          puts '** No todo to complete! **'.red
          return
        end

        todo_to_complete.complete = true
        todo_repo.save_todos_to_file
        puts '** Todo completed! **'.green
      rescue => e
        puts "Error: #{e.message}"
      end
    end

    def self.remove_todo
      begin
        todo_repo = TodoRepository.new_with_data_from(File.expand_path('../../data/data.json', File.dirname(__FILE__)))
        puts '** Remove a Todo! **'.yellow
        id_of_todo_to_remove = enter_id('remove')
        todo_to_remove = todo_repo.todo_by_id(id_of_todo_to_remove)

        if todo_to_remove.nil?
          puts '** No todo to remove! **'.red
          return
        end

        todo_repo.remove(todo_to_remove)
        todo_repo.save_todos_to_file
        puts '** Todo Removed! **'.green
      rescue => e
        puts "Error: #{e.message}"
      end
    end

    def self.time_summary
      all_todos
      puts '** Summarise a Todo! **'.yellow
      todo_repo = TodoRepository.new_with_data_from(File.expand_path('../../data/data.json', File.dirname(__FILE__)))
      id_of_todo_to_summarise = enter_id('summarise')
      todo_to_summarise = todo_repo.todo_by_id(id_of_todo_to_summarise)

      if todo_to_summarise.nil?
        puts '** No todo to summarise! **'.red
        return
      end

      due = Due::Due.new(todo_to_summarise.for_when)
      due.summary_table
    end

  private

    def self.todos_to_table(todos)
      return if todos.count.zero?

      labels = ['Id', 'Todo', 'For When', 'Alert Mins', 'Alert Type', 'Completed']
      rows = []
      todos.sort! { |todo1, todo2| Time.parse(todo2.for_when) <=> Time.parse(todo1.for_when) }

      todos.each do |todo|
        unless todo.for_when.nil?
          row_colour = Time.parse(todo.for_when) < Time.new ? :red : nil
          row_colour = todo.completed? ? :green : row_colour
        end
        rows << self.create_row_for_table(todo, row_colour)
      end

      puts tabulate(labels, rows, { 'indent' => 4, 'style' => 'fancy' })
    end

    def self.create_row_for_table(todo, row_colour)
      columns = []
      columns << ColorizedString[todo.id].colorize(row_colour)
      columns << ColorizedString[todo.title].colorize(row_colour)
      columns << ColorizedString[todo.for_when].colorize(row_colour)
      columns << ColorizedString[todo.alert_mins.rjust(5, ' ')].colorize(row_colour)
      columns << ColorizedString[todo.alert_type.upcase].colorize(row_colour)
      columns << ColorizedString[todo.completed? ? 'Yes' : 'No'].colorize(todo.completed? ? :green : row_colour)
      columns
    end

    def self.enter_id(action)
      print "Enter id of todo to #{action}:>".light_blue
      Integer(gets.chomp)
    end

    def self.enter_title
      print 'Todo title:>'.light_blue
      Todo.title_validate(gets.chomp)
    end

    def self.enter_for_when
      print 'For when:>'.light_blue
      Todo.for_when_validate(gets.chomp)
    end

    def self.enter_alert_mins
      print 'Alert mins:>'.light_blue
      Todo.alert_mins_validate(gets.chomp)
    end

    def self.enter_alert_type
      print 'Alert type:>'.light_blue
      Todo.alert_type_validate(gets.chomp)
    end
  end
end
