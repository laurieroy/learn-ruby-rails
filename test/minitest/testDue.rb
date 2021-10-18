require 'minitest/autorun'
require_relative '../../lib/due/due'

class TestDue < Minitest::Test

  def test_due_difference_seconds_between_dates
    due = Due::Due.new('2020-10-11 12:00:00')
    due.now_date_time = Time.parse('2020-10-12 12:00:00')
    due.calc_difference

    assert_equal(-86_400.0, due.difference)
  end

  def test_due_difference_minutes_between_dates
    due = Due::Due.new('2020-10-11 12:00:00')
    due.now_date_time = Time.parse('2020-10-12 12:00:00')
    due.calc_difference

    assert_equal(-1440, due.calc_mins_till)
  end

  def test_due_difference_hours_between_dates
    due = Due::Due.new('2020-10-11 12:00:00')
    due.now_date_time = Time.parse('2020-10-12 12:00:00')
    due.calc_difference

    assert_equal(-24, due.calc_hours_till)
  end

  def test_due_difference_days_between_dates
    due = Due::Due.new('2020-10-11 12:00:00')
    due.now_date_time = Time.parse('2020-10-12 12:00:00')
    due.calc_difference

    assert_equal(-1, due.calc_days_till)
  end

  def test_due_difference_days_between_dates
    due = Due::Due.new('2020-10-11 12:00:00')
    due.now_date_time = Time.parse('2020-10-12 12:00:00')
    due.calc_difference

    assert_equal(-1, due.calc_days_till)
  end

  def test_due_difference_months_between_dates
    due = Due::Due.new('2020-07-01 00:00:00')
    due.now_date_time = Time.parse('2020-08-01 00:00:00')
    due.calc_difference

    assert_equal(-1, due.calc_months_till)
  end

  def test_due_difference_years_between_dates
    due = Due::Due.new('2019-07-01 00:00:00')
    due.now_date_time = Time.parse('2020-07-02 00:00:00')
    due.calc_difference

    assert(due.calc_years_till >= -0.99)
  end

  def test_due_difference_weeks_between_dates
    due = Due::Due.new('2020-07-01 00:00:00')
    due.now_date_time = Time.parse('2020-08-01 00:00:00')
    due.calc_difference

    assert(-4.43, due.calc_weeks_till)
  end
end
