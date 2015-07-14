# coding: utf-8

example :palleted_png, 'Rendering a palleted PNG with transparency' do |t|
  report = Thinreports::Report.new layout: t.layout_filename
  report.start_new_page do |page|
    page.item(:image).src = t.resource('palleted_png.png')
  end
  report.generate filename: t.output_filename
end
