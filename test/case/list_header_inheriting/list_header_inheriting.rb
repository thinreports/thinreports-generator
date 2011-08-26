# coding: utf-8

CaseRunner.current :list_header_inheriting

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file)
  
  3.times do |t|
    start_new_page
    
    page.list(:list).header do |section|
      section.item(:header).value("Header##{t}")
    end
    
    ((t + 1) * 3).times do
      page.list(:list).add_row
    end
  end
end
