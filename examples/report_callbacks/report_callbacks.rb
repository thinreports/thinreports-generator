# coding: utf-8

example :report_callbacks, 'Callbacks of Report' do |t|
  report = Thinreports::Report.new layout: t.layout_filename

  # A handler called after creating each page in 0.7.7 or lower
  report.events.on :page_create do |e|
    e.page.item(:text1).value('A handler called after creating each page in 0.7.7 or lower')
  end

  # A handler called after creating each page in 0.8 or higher
  report.on_page_create do |page|
    page.item(:text2).value('A handler called after creating each page in 0.8 or higher')
  end

  report.start_new_page
  report.start_new_page

  # on_generate callback in 0.7.7 or lower
  report.events.on :generate do |e|
    e.pages.each {|page| page.item(:text3).value('generate event in 0.7.7 or lower') }
  end

  # Instead of on_generate callback in 0.8 or higher
  report.pages.each do |page|
    page.item(:text4).value('emulation of generate event in 0.8 or higher')
  end

  report.generate filename: t.output_filename
end
