# frozen_string_literal: true

require 'feature_test'

class TestPageNumber < FeatureTest
  feature :page_number do
    report = Thinreports::Report.new layout: template_path

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
