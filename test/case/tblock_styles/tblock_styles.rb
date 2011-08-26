# coding: utf-8

CaseRunner.current :tblock_styles

ThinReports::Report.generate_file(:pdf, CaseRunner.output_file) do
  use_layout(CaseRunner.layout_file)
  
  start_new_page
  
  page.item(:space_single_helvetica).value('Char Space in Single(Helvetica)')
  page.item(:space_single_ipamincho).value('文字間隔 in 単行（IPA明朝）')
  
  page.item(:space_multi_times).value("Char Space\nin Multiple(Times New Roman)")
  page.item(:space_multi_ipamincho).value("文字間隔\nin 複数行（IPA明朝）")
  
  page.values(:left_top      => '左上揃え',
              :left_center   => '左中央揃え',
              :left_bottom   => '左下揃え',
              :center_top    => '中央上揃え',
              :center_center => '中央揃え',
              :center_bottom => '中央下揃え',
              :right_top     => '右上揃え',
              :right_center  => '右中央揃え',
              :right_bottom  => '右下揃え')
  
  page.item(:line_height).value("行間隔2.0\n日本語\nThinReports")
end
