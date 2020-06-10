# frozen_string_literal: true

require 'feature_test'

class TestTextCharacterSpacingFeature < FeatureTest
  feature :text_character_spacing do
    report = Thinreports::Report.new layout: template_path
    report.start_new_page

    assert_pdf report.generate
  end
end
