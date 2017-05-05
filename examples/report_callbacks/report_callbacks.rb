# frozen_string_literal: true

example :report_callbacks, 'Callbacks of Report' do |t|
  report = Thinreports::Report.new layout: t.layout_filename

  report.on_page_create do |page|
    page.item(:text2).value('Rendered by on_page_create')
  end

  report.start_new_page
  report.start_new_page

  report.generate filename: t.output_filename
end
