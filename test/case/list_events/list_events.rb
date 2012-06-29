# coding: utf-8

CaseRunner.current :list_events

ThinReports::Report.generate_file(CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file) do |config|
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
    page.list(:default).add_row :row_name => t + 1
  end
  
  start_new_page
  
  8.times do |t|
    page.list(:default).add_row :row_name => t + 1
  end  
end
