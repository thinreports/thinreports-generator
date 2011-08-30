# coding: utf-8

CaseRunner.current :using_templates

ThinReports.configure do
  generator.pdf.manage_templates = CaseRunner.case_resource
end

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do
  use_layout(CaseRunner.case_resource('using_templates_1.tlf'))
  use_layout(CaseRunner.case_resource('using_templates_2.tlf'), :id => :list_layout)
  
  start_new_page
  
  page.item(:name).value('ThinReports')
  page.item(:desc).value('Ruby用オープンソース帳票ソリューション' * 2)
  
  start_new_page :layout => :list_layout
  
  10.times do |t|
    page.list(:list).add_row :detail => "Detail##{t}"
  end
  
  start_new_page do
    item(:name).value('Ruby')
    item(:desc).value('日本で生まれ世界が育てた言語 Ruby' * 2)
  end
end

ThinReports.config.generator.pdf.manage_templates = false