# coding: utf-8

testcase :text_inline_format, 'Inline formatting for Text' do |t|
  ThinReports::Report.generate :filename => t.output_filename do
    use_layout t.layout_filename
    start_new_page

    test_link_format = 'Link test: <u><link href="http://www.thinreports.org">here</link></u>'
    3.times do
      list.add_row :tblock3 => test_link_format + " (link doesn't work in list)"
    end

    test_formats_in_tblock =<<TBLOCK_CONTENT
<b>Bold</b> format
<i>Italic</i> format
<u>Underline</u> format
<strikethrough>Strikethrough</strikethrough> format
<sub>Subscript</sub> format
<sup>Superscript</sup> format
<font size="14">Font size</font> format
<font name="Times-Roman">Font family</font> format
<color rgb="#ff0000">Font color</color> format
<u><link href="http://www.thinreports.org">Link</link></u> format is available
TBLOCK_CONTENT
    page.item(:tblock4).value(test_formats_in_tblock)
  end
end
