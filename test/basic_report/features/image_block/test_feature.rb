# frozen_string_literal: true

require 'test_helper'
require 'open-uri'
require 'openssl'

class Thinreports::BasicReport::TestImageBlockFeature < Thinreports::FeatureTest[__dir__]
  feature do
    image50x50 = path_of('img50x50.png')
    image200x100 = path_of('img200x100.png')

    report = Thinreports::BasicReport::Report.new layout: template_path
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
    report.page[:thinreports_logo] = StringIO.new(dir.join('thinreports-logo.png').binread)

    report.page.list(:list) do |list|
      3.times { list.add_row in_list: image50x50 }
    end

    assert_pdf report.generate
  end
end
