# coding: utf-8

CaseRunner.current :hidden_shapes

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file)
  
  start_new_page
  
  2.times do
    page.list(:List).add_row
  end
end
