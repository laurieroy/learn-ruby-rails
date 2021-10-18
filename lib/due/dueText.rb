# The due module contains all classes and data to provide due-summary functionality.
module Due
  # The due class takes a given date and provides several period measures until or since that date.
  class DueText
    def self.minutes
      'Minutes'
    end

    def self.hours
      'Hours'
    end 

    def self.days
      'Days'
    end 

    def self.weeks
      'Weeks'
    end 

    def self.months
      'Months'
    end 

    def self.years
      'Years'
    end 

    def self.minutes_prefix
      'min(s)'
    end

    def self.hours_prefix
      'hours(s)'
    end 

    def self.days_prefix
      'day(s)'
    end 

    def self.weeks_prefix
      'week(s)'
    end 

    def self.months_prefix
      'month(s)'
    end 

    def self.years_prefix
      'year(s)'
    end

    def self.period
      'Period'
    end

    def self.duration
      'Duration'
    end 

    def self.measure
      'Measure'
    end 

    def self.since
      'since'
    end 

    def self.till
      'till'
    end 
  end
end
