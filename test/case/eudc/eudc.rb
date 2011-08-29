# coding: utf-8

CaseRunner.current :eudc

ThinReports.configure do |config|
  config.generator.pdf.eudc_ttf = CaseRunner.case_file('eudc.ttf')
end

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file)
  
  start_new_page
  
  page.item(:eudc).value('日本で生まれ世界が育てた言語 Ruby')
end

ThinReports.config.generator.pdf.eudc_ttf = []