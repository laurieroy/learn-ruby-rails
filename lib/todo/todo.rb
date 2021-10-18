require 'Date'
require 'JSON'

module Todo
  # Todo to store Todo details
  class Todo
    attr_accessor :id, :title, :for_when, :alert_mins, :alert_type, :complete
    @@alert_types = ['sms', 'email', 'screen']
    TITLE_MAX_LEN = 100

    def initialize(id, title, for_when, alert_mins, alert_type, complete)
      @id = id
      @title = title
      @for_when = for_when
      @alert_mins = alert_mins
      @alert_type = alert_type
      @complete = complete
    end

    def self.new_todo(id, title, for_when, alert_mins, alert_type, complete)
      title_validate(title)
      for_when_validate(for_when)
      alert_mins_validate(alert_mins)
      alert_type_validate(alert_type)
      Todo.new(id, title, for_when, alert_mins, alert_type, complete)
    end

    def completed?
      @complete.to_s.downcase == 'true'
    end

    def self.new_todo_from_hash(todo_hash)
      Todo.new(todo_hash['id'], todo_hash['title'], todo_hash['for_when'], todo_hash['alert_mins'], todo_hash['alert_type'], todo_hash['complete'])
    end

    def self.title_validate(title)
      raise 'Please enter a valid title for the Todo!' if title.empty?
      raise "Maximum length allowed is #{TITLE_MAX_LEN} charachers!" if title.strip.length > TITLE_MAX_LEN

      title
    end

    def self.for_when_validate(for_when)
      raise 'Please enter a valid for_when date!' unless Date.parse(for_when).instance_of?(Date)

      for_when
    end

    def self.alert_mins_validate(alert_mins)
      begin
        alert_mins_number = Integer(alert_mins)
      rescue => e
        raise 'Please enter a numeric value for alert mins!'
      end

      raise 'Please enter alert mins as 0 for no alert or greater than 0 for alert!' if alert_mins_number.negative?

      alert_mins
    end

    def self.alert_type_validate(alert_type)
      alert_type = alert_type.downcase.strip
      raise 'Please enter a alert type' if alert_type.empty?
      raise "Please enter #{@@alert_types}" unless @@alert_types.include?(alert_type)

      alert_type
    end

    def todo_description
      "Todo: #{@title.light_blue} which is due for: #{@for_when.to_s} with an alert that will be triggered #{@alert_mins.to_s} mins before hand via #{alert_type}"
    end

    def to_hash
      { 'id' => id.to_s, 'title' => title.to_s, 'for_when' => for_when.to_s, 'alert_mins' => alert_mins.to_s, 'alert_type' => alert_type.to_s, 'complete' => complete.to_s }
    end

    def to_json
      to_hash.to_json
    end
  end
end
