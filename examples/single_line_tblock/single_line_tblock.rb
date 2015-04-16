# coding: utf-8

example :single_line_tblock, 'Show a single-line Tblock' do |t|
  Thinreports::Report.generate filename: t.output_filename do
    use_layout(t.layout_filename)
    
    start_new_page
    
    page.item(:fallback_to_ipafont).value('IPA明朝に自動的にフォールバックされる')
    
    page.item(:set_multiline_text).value("１行目\n2行目\n3行目\n4行目\n5行目")
  end
end
