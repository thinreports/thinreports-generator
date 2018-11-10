# frozen_string_literal: true

require 'feature_test'

class TestPalletedPng < FeatureTest
  feature :palleted_png do
    report = Thinreports::Report.new layout: template_path
    report.start_new_page do |page|
      page.item(:image).src = path_of('palleted_png.png')
    end

    assert_pdf report.generate
  end
end
