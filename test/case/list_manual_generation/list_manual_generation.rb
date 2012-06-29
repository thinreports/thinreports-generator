# coding: utf-8

CaseRunner.current :list_manual_generation

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file)
  
  list.header do |h|
    h.item(:header).value(page.no)
  end
  
  25.times do |t|
    if page.list.overflow?
      start_new_page
      list.header :header => page.no
    end
    
    list.page_break if t == 15
    
    list.add_row :detail => t
  end
end
