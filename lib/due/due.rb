
require 'time'
require 'tabulate'
require_relative 'DueText'

# The due module contains all classes and data to provide due-summary functionality.
module Due
  # The due class takes a given date and provides several period measures until or since that date.
  class Due

    # Date time field set via the constructor, and the date-time value the due summary stats are based around.
    attr_accessor :date_time
    # Date time field used to store the current date-time used as part of the due summary calculations.
    attr_accessor :now_date_time
    # The numeric field used to store the time difference between the provided date and the current date and time.
    attr_accessor :difference

    # Class constructor that takes in a DateTime argument to base the due-summary stats on.
    def initialize(the_date_time)
      @date_time = Time.parse(the_date_time)
      @difference = 0.0
    end

    # Uses the puts command to output all the due-summary stats as a line separated text.
    def print_summary
      update_now_date_time
      calc_difference
      puts "#{DueText.minutes} #{till_or_since}: \t #{calc_mins_till.round(2)} #{DueText.minutes_prefix} \n
      #{DueText.hours} #{till_or_since}: \t #{calc_hours_till.round(2)} #{DueText.hours_prefix} \n
      #{DueText.days} #{till_or_since}: \t #{calc_days_till.round(2)} #{DueText.days_prefix} \n
      #{DueText.weeks} #{till_or_since}: \t #{calc_weeks_till.round(2)} #{DueText.weeks_prefix} \n
      #{DueText.months} #{till_or_since}: \t #{calc_months_till.round(2)} #{DueText.months_prefix} \n
      #{DueText.years} #{till_or_since}: \t #{calc_years_till.round(2)} #{DueText.years_prefix}"
    end

    # This method returns an array containing the due-summary stats.
    def summary_array
      row = []
      column = [DueText.minutes, till_or_since, calc_mins_till.round(2), DueText.minutes_prefix]
      row << column
      column = [DueText.hours, till_or_since, calc_hours_till.round(2), DueText.hours_prefix]
      row << column
      column = [DueText.days, till_or_since, calc_days_till.round(2), DueText.days_prefix]
      row << column
      column = [DueText.weeks, till_or_since, calc_weeks_till.round(2), DueText.weeks_prefix]
      row << column
      column = [DueText.months, till_or_since, calc_months_till.round(2), DueText.months_prefix]
      row << column
      column = [DueText.years, till_or_since, calc_years_till.round(2), DueText.years_prefix]
      row << column
    end

    # This method uses the puts command to output all the due-summary stats as a formatted table.
    def summary_table
      update_now_date_time
      calc_difference
      labels = [DueText.period, ' ', DueText.duration, DueText.measure]
      rows = summary_array
      puts tabulate(labels, rows, { 'indent' => 4, 'style' => 'fancy' })
    end

    # This method updates the current date and time regarded as the now current date and time for the due-summary stats.
    def update_now_date_time
      @now_date_time = Time.new
    end

    # This method calculates the due summary time difference between the provided date and the now date.
    def calc_difference
      @difference = @date_time.to_f - @now_date_time.to_f
    end

    # This method returns 'since' or 'till' as a description to describe the time difference.
    def till_or_since
      if @difference.negative?
        DueText.since
      else
        DueText.till
      end
    end

    # This method calculates the due-summary time difference in minutes.
    def calc_mins_till
      (@difference.round(2) / 60.00).round(2)
    end

    # This method calculates the due-summary time difference in hours.
    def calc_hours_till
      (calc_mins_till / 60.00).round(2)
    end

    # This method calculates the due-summary time difference in days.
    def calc_days_till
      (calc_hours_till / 24.00).round(2)
    end

    # This method calculates the due-summary time difference in months.
    def calc_months_till
      (calc_days_till / 31.0).round(2)
    end

    # This method calculates the due-summary time difference in years.
    def calc_years_till
      (calc_months_till / 12.00).round(2)
    end

    # This method calculates the due-summary time difference in weeks.
    def calc_weeks_till
      (calc_days_till / 7.0).round(2)
    end
  end
end
