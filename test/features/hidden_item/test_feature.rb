# frozen_string_literal: true

require 'feature_test'

class TestHiddenItemFeature < FeatureTest
  feature :hidden_item do
    report = Thinreports::Report.new layout: template_path
    2.times { report.list(:List).add_row }

    assert_pdf report.generate
  end
end
