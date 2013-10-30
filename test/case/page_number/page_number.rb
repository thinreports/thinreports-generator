# coding: utf-8

testcase :page_number, 'Draw page-number automatically each pages' do |t|
  # Basic PageNumber
  report = ThinReports::Report.new :layout => t.layout_filename

  report.start_new_page do |page|
    # change visibility
    page.item(:pageno).hide
  end
  report.start_new_page do |page|
    # change style
    page.item(:pageno).styles(:color => 'red', 
                              :bold => true, 
                              :underline => true, 
                              :linethrough => true)
  end

  report.generate :filename => t.output_filename

  # PageNumber is started from 5
  report = ThinReports::Report.new :layout => t.layout_filename
  report.start_page_number_from 5

  10.times { report.start_new_page }

  report.generate :filename => t.resource("#{t.name}_from5.pdf")
end
