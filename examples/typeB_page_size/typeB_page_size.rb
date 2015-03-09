# coding: utf-8

require 'pdf/inspector'

example :typeB_page_size, 'Generate type B(JIS/ISO) size pages' do |t|
  report = ThinReports::Report.new :layout => t.resource('B4_ISO.tlf')
  report.start_new_page

  inspector = PDF::Inspector::Page.analyze(report.generate)
  raise 'Invalid B4 ISO size' unless inspector.pages.first[:size] == [708.66, 1000.63]

  report = ThinReports::Report.new :layout => t.resource('B4_JIS.tlf')
  report.start_new_page

  inspector = PDF::Inspector::Page.analyze(report.generate)
  raise 'Invalid B4 JIS size' unless inspector.pages.first[:size] == [728.5, 1031.8]
end
