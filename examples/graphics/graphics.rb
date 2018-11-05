# frozen_string_literal: true

example :graphics, 'Basic graphics' do |t|
  report = Thinreports::Report.new layout: t.layout_filename
  report.start_new_page
  report.generate filename: t.output_filename
end
