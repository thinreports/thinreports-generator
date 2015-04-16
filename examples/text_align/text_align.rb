# coding: utf-8

example :text_align, 'Sets the text-align style to Text' do |t|
  Thinreports::Report.generate filename: t.output_filename do
    use_layout t.layout_filename
    start_new_page
  end
end
