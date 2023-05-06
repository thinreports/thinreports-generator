# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestHiddenItemFeature < Thinreports::FeatureTest[__dir__]
  feature do
    report = Thinreports::BasicReport::Report.new layout: template_path
    2.times { report.list(:List).add_row }

    assert_pdf report.generate
  end
end
