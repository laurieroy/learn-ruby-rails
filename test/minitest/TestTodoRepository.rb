require 'minitest/autorun'
require_relative '../../lib/todo/todo'
require_relative '../../lib/todo/todoRepository'
require 'pry'

class TestTodoRepository < Minitest::Test
  def test_add
    todo_repo = Todo::TodoRepository.new
    todo = Todo::Todo.new(1, 'test1', '2020-10-10', '11', 'sms', false)

    todo_repo.add(todo)

    assert_equal(1, todo_repo.count)
    assert_equal(todo, todo_repo.todos_all[0])
    assert_equal(todo, todo_repo.todo_by_index(0))
  end

  def test_remove
    todo_repo = Todo::TodoRepository.new

    todo_one = Todo::Todo.new(1, 'test1', '2020-10-10', '11', 'sms', false)
    todo_two = Todo::Todo.new(1, 'test2', '2020-10-10', '11', 'sms', false)
    todo_three = Todo::Todo.new(1, 'test1', '2020-10-10', '11', 'sms', false)
    todo_four = Todo::Todo.new(1, 'test2', '2020-10-10', '11', 'sms', false)

    todo_repo.add(todo_one)
    todo_repo.add(todo_two)
    todo_repo.add(todo_three)
    todo_repo.add(todo_four)

    todo_repo.remove(todo_two)

    assert_equal(3, todo_repo.count)
    assert_equal(todo_one, todo_repo.todos_all[0])
    assert_equal(todo_three, todo_repo.todos_all[1])
    assert_equal(todo_four, todo_repo.todos_all[2])

    assert_equal(todo_one, todo_repo.todo_by_index(0))
    assert_equal(todo_three, todo_repo.todo_by_index(1))
    assert_equal(todo_four, todo_repo.todo_by_index(2))
  end

  def test_update
    todo_repo = Todo::TodoRepository.new
    todo_one = Todo::Todo.new(1, 'test1', '2020-10-10', '11', 'sms', false)

    todo_repo.add(todo_one)
    todo_one.title = 'new test 1'

    assert_equal(todo_one.title, todo_repo.todo_by_index(0).title)
  end
end