require_relative 'todo/todoController'
require 'colorize'
require_relative 'screen/clear'
# require 'tabulate'
require 'timers'

module RubyTodo
  # This is the menu controller class used to provide the top level menu
  class MenuController
    attr_accessor :menu_number_actions, :menu_text_actions

    def initialize
      @menu_number_actions = ['0', '1', '2', '3', '4', '5', '6', '7', '8']
      @menu_number_actions_text = ['Shortcut(s)'.light_blue, '0'.rjust(3, ' '), '1'.rjust(7, ' '), '2'.rjust(8, ' '), '3'.rjust(6, ' '), '4'.rjust(7, ' '), '5'.rjust(6, ' '), '6'.rjust(8, ' '), '7'.rjust(5, ' '), '8'.rjust(2, ' ')]
      @menu_text_actions = ['Menu'.light_blue, 'Help'.yellow, 'Show all todos'.yellow, 'Show pending todos'.yellow, 'Add new todo'.yellow, 'Complete a todo'.yellow,
                            'Remove a todo'.yellow, 'Todo due summary'.yellow, 'Alert agent'.yellow, 'Exit'.yellow]
    end

    def start!
      app_introduction_text
      loop do
        menu_action = enter_menu_action
        break if menu_action.include?('exit') || menu_action.include?('8')

        do_action(menu_action)
      end

      app_exit_text
    end

    def print_menu
      puts ''
      labels = @menu_text_actions
      rows = []
      columns = @menu_number_actions_text
      rows << columns
      puts tabulate(labels, rows, :indent => 4, :style => 'simple')
      puts ''
    end

    def app_introduction_text
      Screen::Screen.clear
      labels = ['Ruby Todo App'.rjust(75, ' ').yellow]
      rows = []
      columns = ['#' * 140]
      rows << columns
      puts tabulate(labels, rows, :indent => 4, :style => 'legacy')
      puts ''
    end

    def app_exit_text
      puts ''
      labels = ['#' * 140]
      rows = []
      columns = ['EXIT'.rjust(70, ' ').yellow]
      rows << columns
      puts tabulate(labels, rows, :indent => 4, :style => 'legacy')
      puts ''
    end

    def enter_menu_action
      menu_action = ''
      until (@menu_number_actions).include?(menu_action) || @menu_text_actions.include?(menu_action)
        print_menu
        print '> '
        response = gets.chomp
        menu_action = response.downcase.strip
      end
      menu_action
    end

    def do_action(menu_action)
      Screen::Screen.clear
      case 
      when menu_action.include?(@menu_text_actions[2].downcase) || menu_action.include?('1')
        Todo::TodoController.all_todos
      when menu_action.include?(@menu_text_actions[3].downcase) || menu_action.include?('2')
        Todo::TodoController.pending_todos
      when menu_action.include?(@menu_text_actions[4].downcase) || menu_action.include?('3')
        Todo::TodoController.add_todo
      when menu_action.include?(@menu_text_actions[5].downcase) || menu_action.include?('4')
        Todo::TodoController.complete_todo
      when menu_action.include?(@menu_text_actions[6].downcase) || menu_action.include?('5')
        Todo::TodoController.remove_todo
      when menu_action.include?(@menu_text_actions[7].downcase) || menu_action.include?('6')
        Todo::TodoController.time_summary
      when menu_action.include?(@menu_text_actions[8].downcase) || menu_action.include?('7')
        alerts_agent_start
      end
    end

    def alerts_agent_start
      puts 'Sending Todo Alert Notifications (1)...'
      timers = Timers::Group.new
      count = 1
      timers.every(5) do
        Screen::Screen.clear
        count += 1
        puts "Sending Todo Alert Notifications (#{count}) ..."
      end
      loop { timers.wait }
    end
  end
end