# coding: utf-8

testcase :page_number, 'Draw page-number automatically each pages' do |t|
  report = ThinReports::Report.new :layout => t.layout_filename

  report.start_new_page

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

  report.start_new_page do |page|
    # change page-number format
    page.item(:pageno).format('--- {page} ---')
  end

  report.generate :filename => t.output_filename
end
