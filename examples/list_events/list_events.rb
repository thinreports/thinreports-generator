# coding: utf-8

example :list_events, 'Basic list events' do |t|
  ThinReports::Report.generate :filename => t.output_filename do
    use_layout(t.layout_filename) do |config|
      config.list do
        events.on :page_footer_insert do |e|
          e.section.item(:event_name).value(':page_footer_insert')
        end
        events.on :footer_insert do |e|
          e.section.item(:event_name).value(':footer_insert')
        end
        events.on :page_finalize do |e|
          e.list.header.item(:event_name).value(':page_finalize')
          e.page.item(:event_name).value(':page_finalize')
        end
      end
    end
    
    start_new_page
    
    2.times do |t|
      list.add_row :row_name => t + 1
    end
    
    start_new_page
    
    8.times do |t|
      list.add_row :row_name => t + 1
    end  
  end
end
