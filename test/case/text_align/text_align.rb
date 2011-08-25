# coding: utf-8

CaseRunner.current :text_align

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file)
  
  start_new_page
end
