# coding: utf-8

example :list_manual_generation, 'Generate list manually' do |t|
  ThinReports::Report.generate(:filename => t.output_filename) do
    use_layout(t.layout_filename)
    
    list.header do |h|
      h.item(:header).value(page.no)
    end
    
    25.times do |t|
      if list.overflow?
        start_new_page
        list.header :header => page.no
      end
      
      list.page_break if t == 15
      
      list.add_row :detail => t
    end
  end
end
