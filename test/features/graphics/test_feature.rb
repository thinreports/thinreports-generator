# frozen_string_literal: true

require 'feature_test'

class TestGraphicsFeature < FeatureTest
  feature :graphics do
    report = Thinreports::Report.new layout: template_path
    report.start_new_page

    assert_pdf report.generate
  end
end
