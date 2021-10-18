require 'todo/todo'
require 'todo/todoRepository'

RSpec.describe 'a todo respository' do
    around(:example, setup_single_todo: true) do |ex|
        @todo_repo = Todo::TodoRepository.new
        @todo = Todo::Todo.new(1, 'test1', '2020-10-10', '11', 'sms', false)

        ex.run

        @todo_repo = nil
        @todo = nil
		end
		
    around(:example, setup_multiple_todo: true) do |ex|
        @todo_repo = Todo::TodoRepository.new

        @todo_one = Todo::Todo.new(1, 'test1', '2020-10-10', '11', 'sms', false)
        @todo_two = Todo::Todo.new(1, 'test2', '2020-10-10', '11', 'sms', false)
        @todo_three = Todo::Todo.new(1, 'test1', '2020-10-10', '11', 'sms', false)
        @todo_four = Todo::Todo.new(1, 'test2', '2020-10-10', '11', 'sms', false)
    
        @todo_repo.add(@todo_one)
        @todo_repo.add(@todo_two)
        @todo_repo.add(@todo_three)
        @todo_repo.add(@todo_four)

        ex.run

        @todo_repo = nil
        @todo_one = nil
        @todo_two = nil
        @todo_three = nil
        @todo_four = nil
    end

    context 'when adding a todo', setup_single_todo: true do
        
        it 'adds the todo' do
            #Arrange
            #Act
            @todo_repo.add(@todo)
            #Assert
            expect(@todo_repo.todos_all[0]).to be_an_instance_of(Todo::Todo) 
        end

        it 'increases the todo count' do
            #Arrange
            #Act
            @todo_repo.add(@todo)
            #Assert
            expect(@todo_repo.count).to eq(1)
        end

    end

    context 'when an invalid todo', setup_single_todo: true do
        
        it 'nil todo raises an error' do
            #Arrange
            todo = nil
            #Act
            #Assert
            expect {@todo_repo.add(todo)}.to raise_error(ArgumentError)
        end

    end
    
    context 'when removing a todo', setup_multiple_todo: true do
        
        it 'the specific todo is removed' do
            #Arrange        
            #Act
            @todo_repo.remove(@todo_two)
            
            #Assert
            expect(@todo_repo.todos_all()).not_to include(@todo_two)
        end

        it 'the todo count decreases' do
            #Arrange
            #Act
            @todo_repo.remove(@todo_two)
            
            #Assert
            expect(@todo_repo.count).to be < 4
        end
          
    end

    context 'when retrieving all todos', setup_multiple_todo: true  do

        it 'all todos are retreived' do
            #Arrange
            #Act
            @all_todos = @todo_repo.todos_all()
            
            #Assert
            expect(@all_todos).to include(@todo_one,@todo_two,@todo_three,@todo_four)
        end

        it 'the todo count stays the same' do
            #Arrange
            #Act
            @all_todos = @todo_repo.todos_all()
            
            #Assert
            expect(@todo_repo.count).to be >= @all_todos.count
        end

    end

    context 'when retrieving a todo', setup_multiple_todo: true do

        it 'the right todo is fetched' do
            #Arrange
            #Act
            retrieved_todo = @todo_repo.todo_by_index(1)
            
            #Assert
            expect(@todo_two).to eq(retrieved_todo)

        end

        it 'the todo count doesnt change' do
            #Arrange
            #Act
            retrieved_todo = @todo_repo.todo_by_index(2)
            
            #Assert
            expect(@todo_repo.count).to eq(4)
        end

    end
end