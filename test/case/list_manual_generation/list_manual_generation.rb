# coding: utf-8

CaseRunner.current :list_manual_generation

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file)
  
  start_new_page
  
  page.list(:list).header do |h|
    h.item(:header).value(page.no)
  end
  
  25.times do |t|
    if page.list(:list).overflow?
      start_new_page
      page.list(:list).header :header => page.no
    end
    
    page.list(:list).page_break if t == 15
    
    page.list(:list).add_row :detail => t
  end
end
