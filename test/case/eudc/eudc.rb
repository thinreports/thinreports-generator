# coding: utf-8

CaseRunner.current :eudc

ThinReports.configure do |config|
  config.generator.pdf.eudc_fonts = CaseRunner.case_resource('eudc.ttf')
end

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file)
  
  start_new_page
  
  page.item(:eudc).value('日本で生まれ世界が育てた言語 Ruby')
  page.values(:eudc_bold        => '太字',
              :eudc_italic      => '斜体',
              :eudc_bold_italic => '太字斜体')
end

ThinReports.config.generator.pdf.eudc_fonts = []