# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestTextCharacterSpacingFeature < Thinreports::FeatureTest[__dir__]
  feature do
    report = Thinreports::BasicReport::Report.new layout: template_path
    report.start_new_page

    assert_pdf report.generate
  end
end
