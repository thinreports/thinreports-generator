# frozen_string_literal: true

require 'feature_test'

class TestTextBlockStyle < FeatureTest
  feature :text_block_style do
    report = Thinreports::Report.new

    report.start_new_page layout: template_path('templates/basic_styles.tlf') do |page|
      page.item(:space_single_helvetica).value('Char Space in Single(Helvetica)')
      page.item(:space_single_ipamincho).value = '文字間隔 in 単行（IPA明朝）'

      page[:space_multi_times] = "Char Space\nin Multiple(Times New Roman)"
      page.item(:space_multi_ipamincho).value("文字間隔\nin 複数行（IPA明朝）")

      page.values(left_top:       '左上揃え',
                  left_center:    '左中央揃え',
                  left_bottom:    '左下揃え',
                  center_top:     '中央上揃え',
                  center_center: '中央揃え',
                  center_bottom: '中央下揃え',
                  right_top:      '右上揃え',
                  right_center:   '右中央揃え',
                  right_bottom:   '右下揃え')

      page.item(:line_height).value("行間隔2.0\n日本語\nThinreports")
    end

    report.start_new_page layout: template_path('templates/font_size.tlf') do |page|
      page[:text_single24].style(:font_size, 24)
      page[:text_single32].style(:font_size, 32)

      page.item(:text_multiple24).style(:font_size, 24)
      page.item(:text_multiple32).style(:font_size, 32)

      page.item(:block_single18).value('サイズ18')
      page.item(:block_single24).style(:font_size, 24).value('サイズ24')
      page.item(:block_single32).style(:font_size, 32).value('サイズ32')

      page.item(:block_multiple18).value("サイズ18\nサイズ18")
      page.item(:block_multiple24).style(:font_size, 24).value("サイズ24\nサイズ24")
      page.item(:block_multiple32).style(:font_size, 32).value("サイズ32\nサイズ32")
    end

    assert_pdf report.generate
  end
end
