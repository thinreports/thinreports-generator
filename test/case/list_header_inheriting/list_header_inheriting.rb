# coding: utf-8

CaseRunner.current :list_header_inheriting

report = ThinReports::Report.new :layout => CaseRunner.layout_file
  
3.times do |t|
  report.list.header do |section|
    section.item(:header).value("Header##{t}")
  end
  
  ((t + 1) * 3).times do
    report.list.add_row
  end
end

report.generate_file CaseRunner.output_file
