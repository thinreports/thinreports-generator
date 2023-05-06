# frozen_string_literal: true

require 'test_helper'

class Thinreports::BasicReport::TestPageNumberFeature < Thinreports::FeatureTest[__dir__]
  feature do
    report = Thinreports::BasicReport::Report.new layout: template_path

    report.start_new_page do |page|
      page.item(:pageno).hide
    end
    report.start_new_page do |page|
      page.item(:pageno).styles(color: 'red',
                                bold: true,
                                underline: true,
                                linethrough: true)
    end

    report.start_new_page count: false
    report.start_new_page count: true

    assert_pdf report.generate
  end
end
