# frozen_string_literal: true

require 'feature_test'
require 'open-uri'

class TestImageBlock < FeatureTest
  feature :image_block do
    image50x50 = path_of('img50x50.png')
    image200x100 = path_of('img200x100.png')

    report = Thinreports::Report.new layout: template_path
    report.start_new_page

    report.page.values(
      pos_top_left: image50x50,
      pos_top_center: image50x50,
      pos_top_right: image50x50,
      pos_center_left: image50x50,
      pos_center_center: image50x50,
      pos_center_right: image50x50,
      pos_bottom_left: image50x50,
      pos_bottom_center: image50x50,
      pos_bottom_right: image50x50
    )

    report.page.item(:overflow).src = image200x100
    report.page[:thinreports_logo] = open('http://www.thinreports.org/assets/logos/thinreports-logo.png')

    report.page.list(:list) do |list|
      3.times { list.add_row in_list: image50x50 }
    end

    assert_pdf report.generate
  end
end
