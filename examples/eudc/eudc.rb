# coding: utf-8

example :eudc, 'Show External Characters' do |t|
  Thinreports.configure do |config|
    config.fallback_fonts = t.resource('eudc.ttf')
  end

  Thinreports::Report.generate(:filename => t.output_filename) do
    use_layout t.layout_filename

    start_new_page

    page.item(:eudc).value('日本で生まれ世界が育てた言語 Ruby')
    page.values(:eudc_bold        => '太字',
                :eudc_italic      => '斜体',
                :eudc_bold_italic => '太字斜体')
  end

  Thinreports.config.fallback_fonts = []
end
