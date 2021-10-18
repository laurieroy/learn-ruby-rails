require 'due/due'
RSpec.describe 'a due summary' do
	let(:due_summary) {Due::Due.new('2021-10-11 12:00:00')}

	# before(:example, do_setup: true) do
	# 	puts 'before...'
	# 	@due_summary = Due::Due.new('2021-10-11 12:00:00')
	# end

	# after(:example, do_setup: true) do
	# 	@due_summary = nil
	# end

	# around(:example, do_setup: true) do |ex|
	# 	@due_summary = Due::Due.new('2021-10-11 12:00:00')
	# 	ex.run
	# 	@due_summary = nil
	# end

	context 'when working out the difference', do_setup: true do
		it 'has minutes' do
			
			due_summary.now_date_time = Time.parse('2020-10-12 12:00:00')

			due_summary.calc_difference

			expect(due_summary.calc_mins_till).to(eq(524_160))
		end

		it 'has hours' do
			due_summary.now_date_time = Time.parse('2020-10-12 12:00:00')

			due_summary.calc_difference

			expect(due_summary.calc_hours_till).to(eq(8_736))
		end
	end

	context 'when given hardcoded values' do
		it 'has teh same minutes' do
			expect(1).to eq(1)
		end
	end


end