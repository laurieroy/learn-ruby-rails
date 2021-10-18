require_relative 'todo'
require 'JSON'

module Todo
  # Todo respository used to persist todos to data file
  class TodoRepository
    attr_accessor :data_file_path, :todos

    def initialize
      @todos = []
    end

    def self.new_with_data_from(data_file_path)
      todo_repo = TodoRepository.new
      todo_repo.data_file_path = data_file_path
      todo_repo.load
      todo_repo
    end

    def count
      @todos.count
    end

    def add(todo)
      new_id = @todos.inject(0) do |memo, existingtodo|
        memo = existingtodo.id.to_i + 1 if existingtodo.id.to_i >= memo
      end

      todo.id = new_id == nil ? 0 : new_id
      @todos << todo
    end

    def todo_by_index(index)
      @todos[index]
    end

    def todo_by_id(remove_todo_by_id)
      matching_todos = @todos.map { |todo| todo if Integer(todo.id) == remove_todo_by_id }.compact
      matching_todos[0]
    end

    def todos_all
      @todos
    end

    def todos_pending
      now_date_time = Time.new
      @todos.map { |todo| todo if Time.parse(todo.for_when) <= now_date_time && !todo.completed? }.compact
    end

    def remove(todo)
      @todos.delete(todo)
    end

    def save_todos_to_file
      puts 'Path not found from here: ' + File.join(File.dirname(__FILE__), '../../') unless File.exist?(data_file_path)
      return if data_file_path.nil?

      File.open(data_file_path, 'w') do |f|
        f.write(to_json)
      end
    end

    def to_hash
      { 'todos' => @todos.map(&:to_json) } # { |my_todo| my_todo.to_json } }
    end

    def to_json
      to_hash.to_json
    end

    def load
      return unless !data_file_path.nil? && File.exist?(data_file_path)

      @todos = []
      todos_hash = JSON.load(File.read(data_file_path)) #Load JSON from file here "../../data/data.json"

      todos_in_json = todos_hash['todos'].to_a
      todos_in_json.map do |todo_in_json|
        todo_hash = JSON.load(todo_in_json)
        @todos << Todo.new_todo_from_hash(todo_hash)
      end
    end
  end
end
