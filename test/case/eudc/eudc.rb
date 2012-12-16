# coding: utf-8

testcase :eudc, 'Show External Characters' do |t|
  ThinReports.configure do |config|
    config.generator.pdf.eudc_fonts = t.resource('eudc.ttf')
  end
  
  ThinReports::Report.generate(:filename => t.output_filename) do
    use_layout t.layout_filename
    
    start_new_page
    
    page.item(:eudc).value('日本で生まれ世界が育てた言語 Ruby')
    page.values(:eudc_bold        => '太字',
                :eudc_italic      => '斜体',
                :eudc_bold_italic => '太字斜体')
  end

  ThinReports.config.generator.pdf.eudc_fonts = []
end
