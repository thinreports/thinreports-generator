# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestPalletedPngFeature < Thinreports::FeatureTest[__dir__]
  feature do
    report = Thinreports::BasicReport::Report.new layout: template_path
    report.start_new_page do |page|
      page.item(:image).src = path_of('palleted_png.png')
    end

    assert_pdf report.generate
  end
end
