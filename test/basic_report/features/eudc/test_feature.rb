# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestEudcFeature < Thinreports::FeatureTest[__dir__]
  feature do
    Thinreports.configure do |config|
      config.fallback_fonts = path_of('eudc.ttf')
    end

    report = Thinreports::BasicReport::Report.new layout: template_path
    report.start_new_page do |page|
      page.item(:eudc).value('日本で生まれ世界が育てた言語 Ruby')
      page.values(
        eudc_bold: '太字',
        eudc_italic: '斜体',
        eudc_bold_italic: '太字斜体'
      )
    end

    assert_pdf report.generate
  end

  def teardown
    Thinreports.config.fallback_fonts = []
  end
end
