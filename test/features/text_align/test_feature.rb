# frozen_string_literal: true

require 'feature_test'

class TestTextAlign < FeatureTest
  feature :text_align do
    report = Thinreports::Report.new layout: template_path
    report.start_new_page

    assert_pdf report.generate
  end
end
