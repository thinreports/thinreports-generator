# coding: utf-8

testcase :character_spacing, 'Sets the character spacing in the Editor' do
  report = ThinReports::Report.new :layout => layout_filename
  report.start_new_page

  report.generate :filename => output_filename
end
