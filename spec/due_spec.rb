require 'due/due'
RSpec.describe 'a due summary' do
	it 'has minutes' do
		due_summary = Due::Due.new('2021-10-11 12:00:00')
		due_summary.now_date_time = Time.parse('2020-10-12 12:00:00')

		due_summary.calc_difference

		expect(due_summary.calc_mins_till).to(eq(524160))
	end

	it 'has hours' do
		due_summary = Due::Due.new('2021-10-11 12:00:00')
		due_summary.now_date_time = Time.parse('2020-10-12 12:00:00')

		due_summary.calc_difference

		expect(due_summary.calc_hours_till).to(eq(8736))
	end
end